{ config, inputs, self, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# Module
	flake.homeManagerModules."kreyren@tsvetan".imports = [
		homeManagerModules.kreyren
		{
			home-manager.users.kreyren.imports = [
				./home-configuration.nix
			];
		}
	];

	# # Standalone declaration
	# flake.homeManagerConfigurations."kreyren@tsvetan" = inputs.home-manager-nixpkgs.lib.homeManagerConfiguration {
	# 	pkgs = import inputs.nixpkgs {
	# 		system = "aarch64-linux";
	# 		nixpkgs.config.allowUnfree = true;
	# 	};
	# 	modules = [
	# 		self.nixosModules.homeManagerConfiguration.kreyren.default

	# 		./home-configuration.nix
	# 	];

	# 	extraSpecialArgs = {
	# 		unstable = import inputs.nixpkgs-unstable {
	# 			system = "x86_64-linux";
	# 			nixpkgs.config.allowUnfree = true;
	# 		};
	# 	};
	# };
}
