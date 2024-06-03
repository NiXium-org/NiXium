{ self, inputs, config, ... }:

# Flake management of PELAGUS system

{
	# Stable
	flake.nixosConfigurations."pelagus" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence

			## An Anime Game
			self.inputs.aagl.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@pelagus"

			# Files
			./services/distributedBuilds.nix
			./services/openssh.nix
			./services/sunshine.nix
			./services/tor.nix

			./configuration.nix
			./hardware-configuration.nix
			./disks.nix
			./security.nix
			# ./weeb.nix
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

	# Unstable
	flake.nixosConfigurations."pelagus-unstable" = inputs.nixpkgs-unstable.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-unstable {
			system = "x86_64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default

			self.inputs.sops.nixosModules.sops
			self.inputs.hm-unstable.nixosModules.home-manager
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence

			## An Anime Game
			self.inputs.aagl-unstable.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@pelagus"

			# Files
			./configuration.nix
			./hardware-configuration.nix
			./distributedBuilds.nix
			# ./weeb.nix
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

	flake.nixosModules.machine-pelagus = ./export.nix;
}
