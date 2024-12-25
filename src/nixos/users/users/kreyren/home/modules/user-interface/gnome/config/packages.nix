{ config, lib, pkgs, nixosConfig,... }:

# Kreyren's management of GNOME-related packages that are needed to make GNOME to run well

let
	inherit (lib) mkIf mkMerge;
in mkIf nixosConfig.services.xserver.desktopManager.gnome.enable (mkMerge [
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
	}."${lib.trivial.release}" or (throw "Release is not implemented: ${lib.trivial.release}")

	{
		home.packages = [
			pkgs.xdg-desktop-portal-gnome
			pkgs.xdg-desktop-portal
		];
	}
])
