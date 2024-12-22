{ config, lib, pkgs, ... }:

let
	inherit (lib) mkMerge;
in mkMerge [
	{
		"24.05" = {
			home.packages = [
				pkgs.gnome.dconf-editor
			];
		};
		"24.11" = {
			home.packages = [
				pkgs.dconf-editor
			];
		};
		"25.05" = {
			home.packages = [
				pkgs.dconf-editor
			];
		};
	}."${lib.trivial.release}" or (throw "Release is not implemented: ${lib.trivial.release}")

	{
		home.packages = [
			pkgs.xdg-desktop-portal-gnome
			pkgs.xdg-desktop-portal
		];
	}
]
