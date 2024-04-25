{ self, inputs, ... }:

# Flake management of SINNENFREUDE system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."sinnenfreude" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			# FIXME(Krey): Do Nouveau
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.home-manager.nixosModules.home-manager
			# self.disko-nixpkgs.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default

			## An Anime Game
			self.inputs.aagl-gtk-on-nix.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@sinnenfreude"

			./configuration.nix
			./hardware-configuration.nix
			./impermenance.nix
			./distributedBuilds.nix
			# ./disko.nix # FIXME(Krey): I don't know how to implement that yet
			# ./remote-unlock.nix
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
}
