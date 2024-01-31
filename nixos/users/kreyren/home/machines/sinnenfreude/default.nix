{ inputs, self, ... }:

{
	# Standalone declaration
	flake.homeManagerConfigurations."raptor@sinnenfreude" = inputs.home-manager-nixpkgs.lib.homeManagerConfiguration {
		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			nixpkgs.config.allowUnfree = true;
		};
		modules = [
			{ home.stateVersion = "23.11"; }

			self.homeManagerModules.kreyren.default

			./home-configuration.nix
		];

		extraSpecialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				nixpkgs.config.allowUnfree = true;
			};
		};
	};

	# # NixOS module (https://github.com/nix-community/home-manager/blob/fcbc70a7ee064f2b65dc1fac1717ca2a9813bbe6/nixos/common.nix#L45)
	# flake.nixosModules.homeManagerConfiguration."raptor@sinnenfreude" = inputs.home-manager-nixpkgs.nixosModule.home-manager {
	# 	modules = {

	# 	};
	# 	extraSpecialArgs = {
	# 		unstable = import inputs.nixpkgs-unstable {
	# 			system = "x86_64-linux";
	# 			nixpkgs.config.allowUnfree = true;
	# 		};
	# 	};
	# };
}
