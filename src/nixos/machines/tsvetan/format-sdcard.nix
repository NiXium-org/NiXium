{ pkgs, lib, config, ... }:

# Adjustments to the sdcard generator to build an EFI image of tsvetan system

let
	inherit (lib) mkForce;
in {
	formatConfigs.sd-aarch64 = {
		# boot.loader.generic-extlinux-compatible.enable = mkForce false;

		# boot.loader.systemd-boot.enable = true;
		# boot.loader.systemd-boot.editor = false;
		# boot.loader.efi.canTouchEfiVariables = true;

		# boot.kernelParams = ["console=ttyS0,115200n8" "console=tty0"];

		idImage = {
			firmwarePartitionOffset = 8;
			firmwareSize = 30;
			# TODO(Krey): Not yet merged https://github.com/NixOS/nixpkgs/pull/259077
			populateFirmwareCommands = ''
				true
			'';
			populateRootCommands = ''
				true
			'';
			# populateFirmwareCommands = ''
			# 	cp ${pkgs.ubootOlimexA64Teres1}/u-boot-sunxi-with-spl.bin firmware/
			# '';
			# postBuildCommands = ''
			# 	dd if=${pkgs.ubootOlimexA64Teres1}/u-boot-sunxi-with-spl.bin of=$img bs=1k seek=8
			# '';
			# compressImage = true;
			expandOnBoot = true;
		};
		users.users.root.password = "0000";

		# config = {
		# 	# fileSystems = mkForce {
		# 	# 	"/boot/firmware" = {
		# 	# 		device = "/dev/disk/by-label/FIRMWARE";
		# 	# 		fsType = "vfat";
		# 	# 		options = [ "nofail" "noauto" ];
		# 	# 	};
		# 	# 	"/nix" = {
		# 	# 		device = "/dev/disk/by-label/NIX_STORE";
		# 	# 		fsType = "btrfs";
		# 	# 	};
		# 	# 	"/" = {
		# 	# 		device = "/dev/disk/by-label/ROOT_NIXOS";
		# 	# 		fsType = "btrfs";
		# 	# 	};
		# 	# };

		# 	sdImage.storePaths = [ config.system.build.toplevel ];
		# };
	};
}
