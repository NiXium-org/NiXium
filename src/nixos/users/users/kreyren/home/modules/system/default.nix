{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.system-kreyren.imports = [
		homeManagerModules.system-flatpak-kreyren
		homeManagerModules.system-gtk-kreyren
		homeManagerModules.system-impermanence-kreyren
	];

	imports = [
		./flatpak
		./gtk
		./impermanence
		./pac
	];
}
