{ config, lib, ... }:

# Nix-based Disk Management of TSVETAN with disko and impermenance on tmpfs

# Formatting strategy:
#    Table: GPT
#    0-30719 = U-BOOT placed on 128th block to not corrupt GPT tables
#    30720-1079295 (1048576) = /boot (EFI FAT32)
#    1079296-20447231 (19367936) = -4GB Encrypted Nix Store
#    20447232-28833791 (2095104) = Encrypted SWAP

let
	inherit (lib) mkMerge;
in {
	config = mkMerge [
		{
			age.secrets.tsvetan-disks-password.file = ../secrets/tsvetan-disks-password.age;
		}

		(if (true) then {
			age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ];

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
						imageSize = "16G"; # Size of the generated image, max 16GB to match the capacity of the eMMC
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

								store = {
									priority = 3;
									size = "100%";
									content = {
										name = "store";
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
									priority = 2;
									size = "2G";
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
			age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
			# FIXME(Krey): Implement a non-impermenant setup
		})
	];

}
