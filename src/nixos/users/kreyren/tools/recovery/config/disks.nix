{ config, lib, ... }:

# Nix-based Disk Management of RECOVERY with disko

# Formatting strategy (WITH impermanence):
#    Table: GPT
#    2048 - 1050623 (1048576) -- 512M EFI System
#    1050624 - 416231423 (415180800) -- 198G Linux filesystem
#    416231424 - 500118158 (83886735) -- 40G Linux Swap

# Formatting strategy (WITHOUT impermanence):
#    Table: GPT
#    2048 - 1050623 (1048576) -- 512M EFI System
#    1050624 - 416231423 (415180800) -- 198G Linux filesystem
#    416231424 - 500118158 (83886735) -- 40G Linux Swap

# Deployment:
#     # nix run 'github:nix-community/disko#disko-install' -- --flake 'github:kreyren/nixos-config#DERIVATION' --disk system /dev/DEVICE

let
	inherit (lib) mkMerge;
in {
	config = mkMerge [
		{
			age.secrets.recovery-disks-password.file = ../secrets/recovery-disks-password.age;

			age.identityPaths = (if config.boot.impermanence.enable
				then [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ]
				else [ "/etc/ssh/ssh_host_ed25519_key" ]);
		}

		# FIXME-QA(Krey): Produces an infinite recursion -- (config.boot.impermanence.enable == true)
		(if (true) then {
			fileSystems."/nix/persist/system".neededForBoot = true;

			# FIXME(Krey): Figure out how to do labels
			disko.devices = {
				nodev."/" = {
					fsType = "tmpfs";
					mountOptions = [
						"size=2G"
						"defaults"
						# set mode to 755, otherwise systemd will set it to 777, which cause problems.
						# relatime: Update inode access times relative to modify or change time.
						"mode=755"
					];
				};

				disk = {
					system = {
						device = "/dev/disk/by-id/ata-SanDisk_SD8SN8U-256G-1006_165139801733"; # NVME SSD in a USB-C Enclosure
						type = "disk";
						content = {
							type = "gpt";
							partitions = {

								boot = {
									type = "EF00"; # EFI System Partition/
									start = "2048";
									end = "1050623"; # +512M
									priority = 1; # Needs to be first partition
									content = {
										type = "filesystem";
										format = "vfat"; # FAT32
										mountpoint = "/boot";
									};
								};

								nix-store = {
									start = "1050624";
									end = "416231423";
									content = {
										name = "nix-store";
										type = "luks";
										settings.allowDiscards = true;

										passwordFile = config.age.secrets.recovery-disks-password.path;

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
									start = "416231424";
									end = "500118158";
									content = {
										name = "swap";
										type = "luks";

										settings.allowDiscards = true;

										passwordFile = config.age.secrets.recovery-disks-password.path;

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
			disk = {
				system = {
					device = "/dev/disk/by-id/ata-CT500MX500SSD1_21052CD42FFF"; # SATA SSD
					type = "disk";
					content = {
						type = "gpt";
						partitions = {

							boot = {
								type = "EF00"; # EFI System Partition/
								start = "4096";
								end = "1052671"; # +512M
								priority = 1; # Needs to be first partition
								content = {
									type = "filesystem";
									format = "vfat"; # FAT32
									mountpoint = "/boot";
								};
							};

							root_nixos = {
								start = "1052672";
								end = "909664255";
								content = {
									name = "root";
									type = "luks";
									settings.allowDiscards = true;

									passwordFile = config.age.secrets.sinnenfreude-disks-password.path;

									initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

									extraFormatArgs = [
										"--use-random" # use true random data from /dev/random, will block until enough entropy is available
										"--label=CRYPT_NIXOS"
									];

									extraOpenArgs = [
										"--timeout 10"
									];

									content = {
										type = "btrfs";
										extraArgs = [ "--label ROOT_NIXOS" ];
										subvolumes = {
											"@" = {
												mountpoint = "/";
												mountOptions = [ "compress=lzo" "noatime" ];
											};
										};
									};
								};
							};

							swap = {
								start = "909664256";
								end = "976773119";
								content = {
									name = "swap";
									type = "luks";

									settings.allowDiscards = true;

									passwordFile = config.age.secrets.sinnenfreude-disks-password.path;

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
		})
	];
}
