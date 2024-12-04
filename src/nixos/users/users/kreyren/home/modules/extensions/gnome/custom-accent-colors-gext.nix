{ pkgs, lib, nixosConfig, ... }:

# Kreyren's configuration of 'custom accent colors' gnome extension

let
	inherit (lib) mkIf mkMerge;
in mkIf nixosConfig.services.xserver.desktopManager.gnome.enable {
	"24.05" = {
		home.packages = [ pkgs.gnomeExtensions.custom-accent-colors ]; # Install the extension

		dconf.settings = {
			"org/gnome/shell/extensions/custom-accent-colors" = {
				accent-color = "purple";
				# FIXME(Krey): Figure out how to get this functionality on 24.11+
				theme-flatpak = true; # Use for flatpak
				theme-gtk3 = true; # Use for GTK3
				theme-shell = true; # Use for shell
			};

			# Set the extension as a user-theme as it's designed this way to work
			"org/gnome/shell/extensions/user-theme" = {
				name = "Custom-Accent-Colors";
			};
		};
	};

	"21.11" = {
		# Deprecated with GNOME 47
	};
}."${lib.trivial.release}"
