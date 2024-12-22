{ self, config, moduleWithSystem, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.default = {
		imports = [
			homeManagerModules.editors-vscode
			homeManagerModules.system-nix
			homeManagerModules.tools-direnv
			homeManagerModules.tools-git
			homeManagerModules.web-browsers-firefox
			homeManagerModules.web-browsers-librewolf
		];
	};

	imports = [
		./users
		./modules
	];
}
