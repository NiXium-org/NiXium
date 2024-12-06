{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.system-kreyren.imports = [
		homeManagerModules.kreyren.system.gtk
	];

	imports = [
		./flatpak
		./gtk
		./impermanence
		./pac
	];
}
