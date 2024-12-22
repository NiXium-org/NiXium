{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.apps-kreyren.inputs = [
	# 	homeManagerModules.apps-vim-kreyren
	# 	#homeManagerModules.apps-vscode-kreyren
	# ];

	imports = [
		./bottles
	];
}
