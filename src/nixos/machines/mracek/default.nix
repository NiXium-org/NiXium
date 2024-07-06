{ self, config, lib, inputs, ... }:

# Flake management of MRACEK system

let
	inherit (lib) mkForce;
in {
	# Main Configuration
	flake.nixosConfigurations."mracek" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
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
			./services/binfmt.nix
			./services/distributedBuilds.nix
			./services/gitea.nix
			./services/monero.nix
			./services/murmur.nix
			./services/navidrome.nix
			./services/openssh.nix
			./services/tor.nix
			./services/vaultwarden.nix
			./services/vikunja.nix

			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/power-management.nix
			./config/remote-unlock.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
			./config/vm-build.nix
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Task to INSTALL the specified derivation on current system including the firmware in a fully declarative way
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-mracek-install = pkgs.writeShellApplication {
			name = "nixos-mracek-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = (builtins.readFile ./scripts/mracek-install.sh);
		};

		# Declare for `nix run`
		apps.nixos-mracek-install.program = self'.packages.nixos-mracek-install;
	};

	# Module export to other systems in the infrastructure
		flake.nixosModules.machine-mracek = ./lib/mracek-export.nix;
}
