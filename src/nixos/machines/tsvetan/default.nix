{ self, config, lib, inputs, ... }:

# Flake management of TSVETAN system

let
	inherit (lib) mkForce;
in {
	# Main Configuration
	flake.nixosModules."nixos-tsvetan" = {
		imports = [
			self.nixosModules.default

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@tsvetan"

			# Files
			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			# ./config/power-management.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
			./config/vm-build.nix

			./services/distributedBuilds.nix
			./services/openssh.nix
			./services/tor.nix
		];
	};

	imports = [
		# ./releases/master.nix
		./releases/stable.nix
		# ./releases/unstable.nix
	];

	# Module export to other systems in the infrastructure
	flake.nixosModules.machine-tsvetan = ./lib/tsvetan-export.nix;
}
