{ self, config, moduleWithSystem, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.default = moduleWithSystem (
		perSystem@{ system }:
		{ ... }: {
			home-manager.imports = [
				homeManagerModules.editors
				homeManagerModules.system
				homeManagerModules.tools
				homeManagerModules.web-browsers
			];

			home-manager.extraSpecialArgs = {
				inherit self;

				aagl = self.inputs.aagl.packages."${system}";
				unstable = self.inputs.nixpkgs-unstable.legacyPackages."${system}";
				staging-next = self.inputs.nixpkgs-staging-next.legacyPackages."${system}";
				polymc = self.inputs.polymc.packages."${system}";
				firefox-addons = self.inputs.firefox-addons.packages."${system}";
			};
		});

	imports = [
		./users
		./modules
	];
}
