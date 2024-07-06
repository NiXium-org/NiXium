{ pkgs, lib, config, ... }:

# Kreyren's configuration of 'custom accent colors' gnome extension for tanvir

# FIXME-QA(Krey): Figure out how to make this work
# let
# 	inherit (lib) mkIf;
# in mkIf config.services.xserver.desktopManager.gnome.enable {
{
	home.packages = [ pkgs.gnomeExtensions.custom-accent-colors ]; # Install the extension

	dconf.settings = {
		"org/gnome/shell/extensions/custom-accent-colors" = {
			accent-color = "purple";
			theme-flatpak = true; # Use for flatpak
			theme-gtk3 = true; # Use for GTK3
			theme-shell = true; # Use for shell
		};

		# Set the extension as a user-theme as it's designed this way to work
		"org/gnome/shell/extensions/user-theme" = {
			name = "Custom-Accent-Colors";
		};
	};
}
