{ self, inputs, ... }:

# Flake management of TUPAC system

{
	flake.nixosConfigurations."tupac" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this
		};

		modules = [
			self.nixosModules.default
#
			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@tupac" # Include home management
			self.nixosModules.users-kira
			self.homeManagerModules."kira@tupac" # Include home management

			# Principals
			self.inputs.ragenix.nixosModules.default
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.hm.nixosModules.home-manager

			## An Anime Game
			self.inputs.aagl.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			# Temporary management
			{
				# Set Locales
				services.xserver = {
					layout = "us";
					xkbVariant = "";
				};
			}

			# Files
			./configuration.nix
			./hardware-configuration.nix
			./file-systems.nix
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			inherit self;
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};
		};
	};

	flake.nixosConfigurations."tupac-unstable" = inputs.nixpkgs-unstable.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-unstable {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this
		};

		modules = [
			self.nixosModules.default
#
			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@tupac" # Include home management
			self.nixosModules.users-kira
			self.homeManagerModules."kira@tupac" # Include home management

			# Principals
			self.inputs.ragenix.nixosModules.default
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.hm-unstable.nixosModules.home-manager

			## An Anime Game
			self.inputs.aagl-unstable.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			{
				# Set layout
				services.xserver = {
					xkb.layout = "us";
					xkb.variant = "";
				};
			}

			# Files
			./configuration.nix
			./hardware-configuration.nix
			./file-systems.nix
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
}
