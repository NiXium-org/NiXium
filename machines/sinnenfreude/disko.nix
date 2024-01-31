{ ... }:

# Nix-based Disk Management of SINNENFREUDE with disko and impermenance on tmpfs

###! * Should have 4096 sectors of unallocated space before the first partition
###! * The partition following should be an **UN**ENCRYPTED bootable /boot partition with FAT32 filesystem of size 512M
###! * The next partiion is expected to be the ENCRYPTED nix-store mounted on /nix with size of -100GB from the end of SSD
###! * Last partition should be an ENCRYPTED SWAP (filesystem not file) with size 100% of the remaining and set up as resume device from hibernation
###! * Impermenance requires to declare the following:
###! ```nix
###! fileSystems = {
###! 	"/" = {
###! 		device = "none";
###! 		fsType = "tmpfs";
###! 		options = [ "size=3G" "mode=755" ];
###! 	};
###! 	"/home/raptor" = {
###! 		device = "none";
###! 		fsType = "tmpfs";
###! 		options = [ "size=4G" "mode=777" ];
###! 	};
###! };

# FIXME(Krey): Should use a keyFile from a flash disk to decrypt

{
	# Taken from previous setup
	boot.initrd.luks.devices."luks-f5e6fd45-31bb-453a-9066-c8cc92b7eab0".device = "/dev/disk/by-uuid/f5e6fd45-31bb-453a-9066-c8cc92b7eab0"; # Rootfs
	boot.initrd.luks.devices."luks-452ab52a-080e-40c0-83ed-a7c9363a4ef7".device = "/dev/disk/by-uuid/452ab52a-080e-40c0-83ed-a7c9363a4ef7"; # SWAP

	disko.devices = {
		disk = {
			system = {
				# FIXME-SECURITY()
				device = "/dev/disk/by-id/ata-CT500MX500SSD1_21052CD42FFF"; # SSD
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
