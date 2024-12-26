{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.default = {
		imports = [
			homeManagerModules.editors-vscode
			homeManagerModules.system
			homeManagerModules.terminal-emulators
			homeManagerModules.tools
			homeManagerModules.web-browsers
		];
	};

	imports = [
		./users
		./modules
	];
}
