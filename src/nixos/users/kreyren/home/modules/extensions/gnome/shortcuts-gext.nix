{ pkgs, lib, config, ... }:

# FIXME-QA(Krey): Figure out how to make this work
# let
# 	inherit (lib) mkIf;
# in mkIf config.services.xserver.desktopManager.gnome.enable {
{
	home.packages = [ pkgs.gnomeExtensions.shortcuts ]; # Install the extension

	# ... Add the configuration
}
