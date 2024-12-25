{ config, lib, pkgs, ... }:

# VM configuration of IGNUCIUS, used for testing prior to deployment

# Relevant: https://github.com/nix-community/disko/issues/668

# Thank you Maroka-chan for the Cryptkey reference! <3 : https://github.com/Maroka-chan/NixOS-config/blob/c97494c2d725bfb79c0776907a6d89e4724ee21f/modules/base/default.nix#L87

let
	inherit (lib) mkForce;
in {
	virtualisation = {
		# nix run -L .#nixosConfigurations.nixos-ignucius-stable.config.system.build.vmWithDisko
		vmVariantWithDisko = {
			virtualisation = {
				fileSystems."/nix/persist/system".neededForBoot = true;
				fileSystems."/nix/persist/users".neededForBoot = true;

				# FIXME-BUG(Krey): This doesn't seem to work
				resolution = {
					x = 1280;
					y = 720;
				};

				# error: EFI variables can be used only with a partition table of type: hybrid, efi, efixbootldr, or legacy+gpt.
				# useBootLoader = true;
				# 	# Resolve configuration config
				# 	fileSystems."/boot".device = mkForce "/dev/disk/by-label/ESP";

				# FIXME(Krey): Replace the secrets with dummies so that this can be used by others as well
				# Mount local .ssh directory, so the secrets can be decrypted.
				sharedDirectories."secrets_decryption_key" = {
					source = "/nix/persist/users/kreyren/.ssh";
					target = dirOf (builtins.head config.age.identityPaths);
				};
			};

			services.displayManager.autoLogin.user = "kreyren";

			# services.xserver.enable = mkForce false;
			# services.xserver.desktopManager.gnome.enable = mkForce false;
			# services.xserver.displayManager.gdm.enable = mkForce false;

			# QEMU VM doesn't provide the relevant endpoints
			services.smartd.enable = mkForce false; # Disable S.M.A.R.T. Daemon

			# No internet connection so these will fail on startup
			services.tor.enable = mkForce false;
			services.openssh.enable = mkForce false;
			virtualisation.waydroid.enable = mkForce false;
			# networking.useDHCP = mkForce false;
			# networking.interfaces.wlp2s0.useDHCP = mkForce false;
			# networking.interfaces.docker0.useDHCP = mkForce false;
			# networking.interfaces.wwp0s29u1u4i6.useDHCP = mkForce false;

			# It errors out as we don't have the /proc/acpi/ibm/thermal in QEMU
			services.thinkfan.enable = mkForce false; # Disable thinkfan service

			# Use a Dummy Cryptkey so that we don't have to input disk password
				# disko.devices.disk.cryptkey = {
				# 	type = "disk";
				# 	content.type = "gpt";

				# 	content.partitions.cryptkey = {
				# 		size = "4096";
				# 		label = "CRYPTKEY";

				# 		content = {
				# 			type = "filesystem";
				# 			format = "vfat";
				# 		};
				# 	};
				# };

				# disko.devices.disk.system.content.preCreateHook = ''
				# 	mkdir -p /dev/disk/by-partlabel/
				# 	dd bs=1024 count=4 if=/dev/zero of=/dev/disk/by-partlabel/CRYPTKEY iflag=fullblock
				# 	chmod 0400 /dev/disk/by-partlabel/CRYPTKEY
				# '';

				# disko.devices.disk.system.content.postCreateHook = ''
				# 	mkdir -p /dev/disk/by-partlabel/
				# 	dd bs=1024 count=4 if=/dev/zero of=/dev/disk/by-partlabel/CRYPTKEY iflag=fullblock
				# 	chmod 0400 /dev/disk/by-partlabel/CRYPTKEY
				# '';

				# # Configure the system to use the CRYPTKEY
				# disko.devices.disk.system.content.partitions.store.content.settings = {
				# 	keyFileSize = 4096;
				# 	keyFile = "/dev/disk/by-partlabel/CRYPTKEY";

				# 	# passwordFile = mkForce ""; # Unset Disk Password for the store
				# 	fallbackToPassword = false;
				# };
				# disko.devices.disk.system.content.partitions.store.content.passwordFile = mkForce (pkgs.writeText "ignucius-disks-password" "000000").outPath;

				# disko.devices.disk.system.content.partitions.swap.content.passwordFile = mkForce (pkgs.writeText "ignucius-disks-password" "000000").outPath;


				# It's not needed for VM tests and takes a significant amount of space (~30G)
				# disko.devices.disk.system.content.partitions.swap.size = mkForce null; # Unset swap partition

			# Set Default Passwords For Users
				users.users.kreyren = {
					hashedPasswordFile = mkForce null;
					password = "a"; # Fastest to brute force password
				};

				users.users.root.password = "a"; # Fastest to brute force password
		};
	};
}
