{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.web-browsers.default.imports = [
		homeManagerModules.web-browsers-firefox
		homeManagerModules.web-browsers-librewolf
	];

	imports = [
		./firefox
		./librewolf
	];
}
