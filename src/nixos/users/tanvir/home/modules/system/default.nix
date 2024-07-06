{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.tanvir.system.default = [
	# 	homeManagerModules.tanvir.system.gtk
	# 	homeManagerModules.tanvir.system.dconf
	# ];

	imports = [
		./dconf
		./gtk
		./impermanence
		./nix
	];
}
