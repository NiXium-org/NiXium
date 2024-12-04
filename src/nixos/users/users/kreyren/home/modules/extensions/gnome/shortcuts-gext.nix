{ pkgs, lib, nixosConfig, ... }:

let
	inherit (lib) mkIf;
in mkIf nixosConfig.services.xserver.desktopManager.gnome.enable {
	home.packages = [ pkgs.gnomeExtensions.shortcuts ]; # Install the extension

	# ... Add the configuration
}
