{ config, lib, pkgs, ... }:

# Common Home-Manager configuration across all systems for Tanvir
let
	inherit (lib) mkIf;
in {
	home.username = "tanvir";
	# home.homeDirectory = ("/home/" + config.home.username);
	home.homeDirectory = "/home/tanvir";

	systemd.user.startServices = true; # Start all needed services on activation and deactivate the obsolets instead of suggesting what to do

	# Global Packages Installed On ALL Systems
	home.packages = [
		pkgs.keepassxc
		pkgs.wcalc
		pkgs.ripgrep
		pkgs.pciutils # for lspci
		pkgs.file
		pkgs.tree

		# FIXME(Krey): This should be only enabled on GNOME
		pkgs.xdg-desktop-portal-gnome
		pkgs.xdg-desktop-portal
		pkgs.gnome.dconf-editor

		pkgs.cryptsetup

		pkgs.xclip
		pkgs.torsocks

		pkgs.wakeonlan

		pkgs.ix
	];
}
