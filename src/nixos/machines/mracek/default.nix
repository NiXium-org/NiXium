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
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			# self.disko-nixpkgs.nixosModules.disko

			# Users
			#self.nixosModules.users-kreyren
			#self.homeManagerModules.kreyren.default
			# self.inputs.home-manager-nixpkgs.nixosModules.home-manager
			# {
			# 	home-manager.users.raptor = import ../../nixos/users/kreyren/home/machines/sinnenfreude/home-configuration.nix;
			# }

			# Config
			./configuration.nix
			./hardware-configuration.nix
			./impermenance.nix
			./security.nix
			./lanzaboote.nix
			./distributedBuilds.nix
			# ./disko.nix # FIXME(Krey): I don't know how to implement that yet
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
