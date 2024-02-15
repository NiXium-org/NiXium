{ inputs, self, ... }:

{
	# Standalone declaration
	flake.homeManagerConfigurations."kreyren@sinnenfreude" = inputs.home-manager-nixpkgs.lib.homeManagerConfiguration {
		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			nixpkgs.config.allowUnfree = true;
		};
		modules = [
			{ home.stateVersion = "23.11"; }

			self.nixosModules.homeManagerConfiguration.kreyren.default

			./home-configuration.nix
		];

		extraSpecialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				nixpkgs.config.allowUnfree = true;
			};
		};
	};

	# NixOS module (https://github.com/nix-community/home-manager/blob/fcbc70a7ee064f2b65dc1fac1717ca2a9813bbe6/nixos/common.nix#L45)
	flake.homeConfigurations."kreyren@sinnenfreude" = inputs.home-manager-nixpkgs.nixosModule.home-manager {
		modules = [
			#self.homeManagerModules.kreyren.default # Include default home modules

			{
				home.packages = [
					inputs.nixpkgs.legacyPackages.x86_64-linux.htop
				];
			}

			#./home-configuration.nix # Add SINNENFREUDE specific configuration
		];
		extraSpecialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				nixpkgs.config.allowUnfree = true;
			};
		};
	};
}
