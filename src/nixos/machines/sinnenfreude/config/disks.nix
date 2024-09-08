{ config, lib, ... }:

# Nix-based Disk Management of SINNENFREUDe with disko and impermenance on tmpfs

# Formatting strategy (Impermanence):
#    Table: GPT
#    4096 - 1052671 (1048576) [512M] -- EFI BOOT with FAT32
#    1052672-767057919 (766005248) -- -100G Nix Store with BTRFS
#    767057920-976771071 (209713152) -- Encrypted SWAP

# Formatting strategy (WITHOUT impermanence):
#    Table: GPT
#    4096 - 1052671 (1048576) -- 512M EFI System
#    1052672 - 909664255 (908611584) -- 433.3G Linux filesystem
#    909664256 - 976773119 (67108864) -- 32G Linux filesystem

# Deployment:
#     # nix run 'github:nix-community/disko#disko-install' -- --flake 'github:kreyren/nixos-config#sinnenfreude' --disk system /dev/disk/by-id/ata-CT500MX500SSD1_21052CD42FFF

# FIXME(Krey): Refer to https://github.com/nix-community/disko/issues/490

# Reference: https://github.com/ryan4yin/nix-config/blob/82dccbdecaf73835153a6470c1792d397d2881fa/hosts/12kingdoms-suzu/disko-fs.nix#L21

# Reference: https://github.com/lilyinstarlight/foosteros/blob/ccaca3910a61ee790f9cfd000cf77074524676b8/hosts/minimal/disks.nix#L4

# FIXME(Krey): This works surprisingly well, but it:
# * Doesn't manage secrets

let
	inherit (lib) mkMerge;
in mkMerge [
	{
		age.secrets.sinnenfreude-disks-password.file = ../secrets/sinnenfreude-disks-password.age;

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
					"size=9G"
					"defaults"
					# set mode to 755, otherwise systemd will set it to 777, which cause problems.
					# relatime: Update inode access times relative to modify or change time.
					"mode=755"
				];
			};

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

							nix-store = {
								start = "1052672";
								end = "885274623";
								content = {
									name = "nix-store";
									type = "luks";
									settings.allowDiscards = true;

									passwordFile = config.age.secrets.sinnenfreude-disks-password.path;

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
								start = "885274624";
								end = "937701375";
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
]
