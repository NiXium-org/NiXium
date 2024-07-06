{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.tanvir.web-browsers.default.imports = [
	# 	homeManagerModules.tanvir.web-browsers.firefox
	# 	homeManagerModules.tanvir.web-browsers.librewolf
	# ];

	imports = [
		./firefox
		./librewolf
	];
}
