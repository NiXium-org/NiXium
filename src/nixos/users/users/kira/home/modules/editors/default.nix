{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.editors-kira.inputs = [
	# 	homeManagerModules.editors-vim-kira
	# 	#homeManagerModules.editors-vscode-kira
	# ];

	imports = [
		./vim
		./vscode
	];
}
