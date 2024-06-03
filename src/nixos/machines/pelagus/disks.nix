{ config, lib, ... }:

# Nix-based Disk Management of PELAGUS with disko and impermenance on tmpfs

# Formatting strategy:
#    Table: GPT
#    4096 - 1052671 (1048576)  -- 512M BOOT as FAT32
#    1052672 - 885274623 (884221952)  -- Nix store as encrypted BTRFS
#    885274624 - 937701375 (52426752) -- 25 GB encrypted SWAP

# Deployment:
#     # nix run 'github:nix-community/disko#disko-install' -- --flake 'github:kreyren/nixos-config#pelagus' --disk system /dev/disk/by-id/ata-LITEON_EP1-KB480_002704102226

# FIXME(Krey): Refer to https://github.com/nix-community/disko/issues/490

# Reference: https://github.com/ryan4yin/nix-config/blob/82dccbdecaf73835153a6470c1792d397d2881fa/hosts/12kingdoms-suzu/disko-fs.nix#L21

# Reference: https://github.com/lilyinstarlight/foosteros/blob/ccaca3910a61ee790f9cfd000cf77074524676b8/hosts/minimal/disks.nix#L4

# FIXME(Krey): This works surprisingly well, but it:
# * Doesn't manage secrets

let
	inherit (lib) mkIf;
in {
	age.secrets.pelagus-disks-password.file = ./secrets/disks-password.age;

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

		# FIXME-QA(Krey): This should be in user setup
		nodev."/home/kreyren" = {
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
				device = "/dev/disk/by-id/ata-LITEON_EP1-KB480_002704102226"; # NVME SSD
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

								passwordFile = config.age.secrets.pelagus-disks-password.path;

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

								passwordFile = config.age.secrets.pelagus-disks-password.path;

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
}
