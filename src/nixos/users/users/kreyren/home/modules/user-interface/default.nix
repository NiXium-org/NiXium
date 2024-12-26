{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.ui-kreyren.imports = [
		homeManagerModules.ui-gnome-kreyren
	];

	imports = [
		./gnome
	];
}
