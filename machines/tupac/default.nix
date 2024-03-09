{ self, inputs, ... }:

# Flake management of TUPAC system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
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
			self.inputs.home-manager.nixosModules.home-manager

			# Files
			./configuration.nix
			./hardware-configuration.nix
			./file-systems.nix
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};
		};
	};
}
