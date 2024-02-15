{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kreyren-editors-default.inputs = [
		homeManagerModules.kreyren-editors-vim
		homeManagerModules.kreyren-editors-vscode
	];

	imports = [
		./vim
		./vscode
	];
}
