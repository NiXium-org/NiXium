{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.editors-tanvir.inputs = [
	# 	homeManagerModules.editors-vim-tanvir
	# 	#homeManagerModules.editors-vscode-tanvir
	# ];

	imports = [
		./vim
		./vscode
	];
}
