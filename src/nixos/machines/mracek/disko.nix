{ ... }:

# Nix-based Disk Management of MRACEK with disko and impermenance on tmpfs

# Formatting strategy:
#    0-2047 = BIOS
#    2048-1050623 (1048576) i.e. 512M = /boot (EFI FAT32)
#    -100G = nix-store (btrfs encrypted with known passphrase)
#    100% = swap (encrypted with known passphrase)

# FIXME(Krey): Should use a keyFile from a flash disk that can be panic-wiped remotely to decrypt

# FIXME(Krey): Refer to https://github.com/nix-community/disko/issues/490

{
	# Taken from previous setup
	boot.initrd.luks.devices."luks-3f91458d-a1a5-4351-a422-1470844800f2".device = "/dev/disk/by-uuid/3f91458d-a1a5-4351-a422-1470844800f2"; # Rootfs

	# FIXME(Krey): Figure out how to do labels
	disko.devices = {
		disk = {
			system = {
				# FIXME-SECURITY(Krey): Do not expose hardware info
				device = "/dev/disk/by-id/ata-Micron_M600_MTFDDAK256MBF_14380F0D8268"; # SSD
				type = "disk";
				content = {
					type = "gpt";
					partitions = {
						# NOTE(Krey): Do NOT encrypt
						ESP = {
							type = "EF00"; # EFI System Partition
							size = "512M"; # 1024M = 1G -> This is one half
							content = {
								type = "filesystem";
								format = "vfat"; # FAT32
								mountpoint = "/boot";
							};
						};
						# FIXME(Krey): Encrypt this with known passphrase
						nix-store = {
							# type = "???"; # Set for purity?
							size = "-100G";
							content = {
								type = "filesystem";
								format = "btrfs";
								mountpoint = "/nix";
								#mountOptions = [ "subvol=@" ]; # Do we need this?
							};
						};
						# FIXME(Krey): This swap has to be encrypted, randomEncryption doesn't work with hibernation as you won't be able to decrypt it during bootloader phase unless you can guess the random passphrase
						# NOTE(Krey): The passphrase should be the same as the one for nix-store atm
						swap = {
							# type = "???"; # Set for purity?
							size = "100%";
							content = {
								type = "swap";
								resumeDevice = true; # resume from hiberation from this device
							};
						};
						# Impermanance stuff
						rootfs = {
							fsType = "tmpfs";
							mountOptions = [ "size=3G" "mode=755" ];
						};
						"/home/raptor" = {
							fsType = "tmpfs";
							mountOptions = [ "size=4G" "mode=777" ];
						};
					};
				};
			};
		};
	};

	# Impermanence
	environment.persistence."/nix/persist/system" = {
		hideMounts = true; # For added security and less clutter in the system
		directories = [
			"/var/log" # Logs
			"/var/lib/bluetooth" # Keep bluetooth configs
			"/var/lib/nixos" # Nix stuff? Dunno why
			"/var/lib/systemd/coredump" # Dunno
			"/etc/NetworkManager/system-connections" # WiFi configs
			{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; } # No idea
		];
		files = [
			"/etc/machine-id" # To avoid confusing systemd
			{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; } # No idea

			# To make SSH connections consistent without having to refresh known_hosts
			"/etc/ssh/ssh_host_ed25519_key"
			"/etc/ssh/ssh_host_ed25519_key.pub"
		];
		# FIXME(Krey): Move this in user declaration?
		# FIXME-SECURITY(Krey): Username is confidential, using placeholder atm
		users.raptor = {
			directories = [
				# FIXME(Krey): This is projected to be deprecated as home-manager will be part of our nix-config
				".config/home-manager"
			];
			# files = [
			# 	".screenrc"
			# ];
		};
	};
}
