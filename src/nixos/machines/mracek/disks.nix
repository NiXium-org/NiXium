{ config, lib, ... }:

# Nix-based Disk Management of TSVETAN with disko and impermenance on tmpfs

# Formatting strategy:
#    Table: GPT
#    2048 - 1050623 (1048576) -- 512M EFI System
#    1050624 - 913858559 (912807936) -- -30G nix store BTRFS
#    913858560 - 976773119 (62914560) -- 100% Encrypted swap

# Deployment:
#     # nix run 'github:nix-community/disko#disko-install' -- --flake 'github:kreyren/nixos-config#mracek' --disk system /dev/disk/by-id/ata-WDC_WDS500G2B0A-00SM50_21101J456803

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
			age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ]; # Change the identity path to use our disko path

			age.secrets.mracek-disks-password.file = ./secrets/disks-password.age; # Supply password for disk encryption
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
						"mode=755"
					];
				};

				disk = {
					system = {
						device = "/dev/disk/by-id/ata-WDC_WDS500G2B0A-00SM50_21101J456803"; # SATA SSD
						type = "disk";
						content = {
							type = "gpt";
							partitions = {

								boot = {
									type = "EF00"; # EFI System Partition/
									start = "30720"; # Give U-Boot 30MB for it's files
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
									end = "913858559";
									content = {
										name = "nix-store";
										type = "luks";
										settings.allowDiscards = true;

										passwordFile = config.age.secrets.mracek-disks-password.path;

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
									start = "913858560";
									end = "976773119";
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
