{ self, inputs, ... }:

# Flake management of PELAGUS system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."lp4a" = inputs.nixpkgs.lib.nixosSystem {
		system = "riscv64-linux";

		pkgs = import inputs.nixpkgs {
			system = "riscv64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.home-manager.nixosModules.home-manager
			self.inputs.impermanence.nixosModules.impermanence

			# Users
			self.nixosModules.users-kreyren
			# self.homeManagerModules."kreyren@lp4a"

			# Files
			./configuration.nix
			./hardware-configuration.nix
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
