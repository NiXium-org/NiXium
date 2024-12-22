{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.kreyren.web-browsers.default.imports = [
	# 	homeManagerModules.kreyren.web-browsers.firefox
	# 	homeManagerModules.kreyren.web-browsers.librewolf
	# ];

	imports = [
		./firefox
	];
}
