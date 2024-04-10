{ self, inputs, ... }:

# Flake management of PELAGUS system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
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
			self.inputs.home-manager.nixosModules.home-manager
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@pelagus"

			# Files
			./configuration.nix
			./hardware-configuration.nix
			./distributedBuilds.nix
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
