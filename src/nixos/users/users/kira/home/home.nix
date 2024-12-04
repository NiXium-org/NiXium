{ config, pkgs, ... }:

# Common Home-Manager configuration across all systems for KIRAs

{
	home.username = "kira";
	# home.homeDirectory = ("/home/" + config.home.username);
	home.homeDirectory = "/home/kira";

	nix.settings.trusted-users = [ "kira" ]; # Add Kira in Trusted-Users

	xsession.numlock.enable = true; # Enable numlock on boot

	# Global Packages Installed On ALL Systems
	home.packages = [
		pkgs.keepassxc
		pkgs.xorg.xkill
		pkgs.htop
		pkgs.wget
		pkgs.wcalc
		pkgs.ripgrep
		pkgs.pciutils # for lspci
		pkgs.file
		pkgs.tree

		pkgs.xclip
		pkgs.flameshot
		pkgs.mpv
		pkgs.torsocks

		pkgs.ix
	];
}
