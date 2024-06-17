{ self, config, lib, inputs, ... }:

# Flake management of MRACEK system

let
	inherit (lib) mkForce mkIf;
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

			./config/disks.nix
			./config/firmware.nix
			./config/hardware-configuration.nix
			./config/remote-unlock.nix
			./config/security.nix
			./config/setup.nix
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

	# Minimal NixOS Configuration used to perform updates in a fully declarative way
		flake.nixosConfigurations."mracek-recovery" = inputs.nixpkgs.lib.nixosSystem {
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

				# Files
				./services/distributedBuilds.nix
				./services/gitea.nix
				./services/monero.nix
				./services/murmur.nix
				./services/navidrome.nix
				./services/openssh.nix
				./services/tor.nix
				./services/vaultwarden.nix
				./services/vikunja.nix

				./hardware-configuration.nix
				./security.nix
				./disks.nix
			];

			# FIXME-QA(Krey): This needs better management
			specialArgs = {
				inherit self;
				stable = import inputs.nixpkgs {
					system = "x86_64-linux";
					config.allowUnfree = true;
				};
				unstable = import inputs.nixpkgs-unstable {
					system = "x86_64-linux";
					config.allowUnfree = true;
				};
			};
		};

	# Module export to other systems in the infrastructure
		flake.nixosModules.machine-mracek = ./lib/mracek-export.nix;
}
