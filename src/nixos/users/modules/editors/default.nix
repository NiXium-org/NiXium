{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.editors.inputs = [
		homeManagerModules.editors-vscode
	];

	imports = [
		./vscode
	];
}
