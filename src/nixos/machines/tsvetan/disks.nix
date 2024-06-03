{ config, lib, ... }:

# Nix-based Disk Management of TSVETAN with disko and impermenance on tmpfs

# Formatting strategy:
#    Table: GPT
#    0-30719 = U-BOOT placed on 128th block
#    30720-1079295 (1048576) = /boot (EFI FAT32)
#    1079296-20447231 (19367936) = -4GB Encrypted Nix Store
#    20447232-28833791 (2095104) = Encrypted SWAP

# Deployment:
#    # LC_ALL=C nix shell 'github:nix-community/disko#disko-install' 'nixpkgs#nixos-install-tools' --command "disko-install --flake 'github:kreyren/nixos-config#tsvetan' --disk system /dev/disk/by-id/mmc-R1J56L_0xd5a44fe1"

# FIXME(Krey): Refer to https://github.com/nix-community/disko/issues/490

# Reference: https://github.com/ryan4yin/nix-config/blob/82dccbdecaf73835153a6470c1792d397d2881fa/hosts/12kingdoms-suzu/disko-fs.nix#L21

# Reference: https://github.com/lilyinstarlight/foosteros/blob/ccaca3910a61ee790f9cfd000cf77074524676b8/hosts/minimal/disks.nix#L4

# FIXME(Krey): This works surprisingly well, but it:
# * Doesn't manage secrets
# * Doesn't automatically connect to the WiFi
# .. So the system is unusable as we can't log-in to it

let
	inherit (lib) mkMerge;
in {
	config = mkMerge [
		{
			age.secrets.tsvetan-disks-password.file = ./secrets/disks-password.age;

			age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];
		}

		(if (true) then {
			fileSystems."/nix/persist/system".neededForBoot = true;

			# FIXME(Krey): Figure out how to do labels
			disko.devices = {
				nodev."/" = {
					fsType = "tmpfs";
					mountOptions = [
						"size=1G"
						"defaults"
						# set mode to 755, otherwise systemd will set it to 777, which cause problems.
						# relatime: Update inode access times relative to modify or change time.
						"mode=755"
					];
				};

				# FIXME-QA(Krey): This should be in user's home-manager
				nodev."/home/kreyren" = {
					fsType = "tmpfs";
					mountOptions = [
						"size=1G"
						"defaults"
						# set mode to 755, otherwise systemd will set it to 777, which cause problems.
						# relatime: Update inode access times relative to modify or change time.
						"mode=755"
					];
				};

				disk = {
					system = {
						device = "/dev/disk/by-id/mmc-R1J56L_0xd5a44fe1"; # eMMC
						type = "disk";
						content = {
							type = "gpt";
							partitions = {

								boot = {
									type = "EF00"; # EFI System Partition/
									start = "30720"; # Give U-Boot 30MB for it's files
									end = "1079295"; # +512M
									priority = 1; # Needs to be first partition
									content = {
										type = "filesystem";
										format = "vfat"; # FAT32
										mountpoint = "/boot";
									};
								};

								nix-store = {
									start = "1079296";
									end = "20447231";
									content = {
										name = "nix-store";
										type = "luks";
										settings.allowDiscards = true;

										passwordFile = config.age.secrets.tsvetan-disks-password.path;

										initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

										extraFormatArgs = [
											"--use-random" # use true random data from /dev/random, will block until enough entropy is available
											"--label=CRYPT_NIX"
										];

										extraOpenArgs = [
											"--timeout 10"
										];

										content = {
											type = "btrfs";
											extraArgs = [ "--label NIX_STORE" ];
											subvolumes = {
												"@nix" = {
													mountpoint = "/nix";
													mountOptions = [ "compress=lzo" "noatime" ];
												};
												"@persist" = {
													mountpoint = "/nix/persist/system";
													mountOptions = [ "compress=lzo" "noatime" ];
												};
											};
										};
									};
								};

								swap = {
									start = "20447232";
									end = "28833791";
									content = {
										name = "swap";
										type = "luks";

										settings.allowDiscards = true;

										passwordFile = config.age.secrets.tsvetan-disks-password.path;

										initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

										extraFormatArgs = [
											"--use-random" # use true random data from /dev/random, will block until enough entropy is available
											"--label=CRYPT_SWAP"
										];

										extraOpenArgs = [
											"--timeout 10"
										];

										content = {
											# FIXME-QA(Krey): Add label 'SWAP'
											type = "swap";
											resumeDevice = true; # resume from hiberation from this device

											extraArgs = [
												"--label SWAP"
											];
										};
									};
								};
							};
						};
					};
				};
			};
		} else {
			# FIXME(Krey): Implement a non-impermenant setup
		})
	];

}
