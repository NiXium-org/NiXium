{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# FIXME(Krey): Does not work?
	# flake.homeManagerModules.editors.inputs = [
	# 	homeManagerModules.editors-vscode
	# ];

	imports = [
		./vscode
	];
}
