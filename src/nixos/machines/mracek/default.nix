{ self, lib, inputs, ... }:

# Flake management of MRACEK system

let
	inherit (lib) mkForce;
in {
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."mracek" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
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

			./configuration.nix
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

	flake.nixosModules.machine-mracek = ./export.nix;
}
