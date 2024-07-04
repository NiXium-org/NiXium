{ self, config, lib, inputs, ... }:

# Flake management of TSVETAN system

let
	inherit (lib) mkForce mkIf;
in {
	# Main Configuration
	flake.nixosConfigurations."tsvetan" = inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		pkgs = import inputs.nixpkgs {
			system = "aarch64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
		};

		modules = [
			self.nixosModules.default # Load NiXium's Global configuration

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.disko.nixosModules.disko
			self.inputs.nixos-generators.nixosModules.all-formats

			# Files
			./services/distributedBuilds.nix
			./services/openssh.nix
			./services/tor.nix

			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/power-management.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
			./config/vm-build.nix
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Module export to other systems in the infrastructure
		flake.nixosModules.machine-tsvetan = ./lib/tsvetan-export.nix;
}
