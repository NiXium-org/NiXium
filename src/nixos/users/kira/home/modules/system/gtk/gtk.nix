{ pkgs, ... }:

{
	# NOTE(Krey): Causes hm-activate to fail due to ~/.config/gtk-4.0/gtk.css being in a way
	# gtk = {
	# 	theme = {
	# 		name = "Adw-gtk3-dark";
	# 		package = pkgs.adw-gtk3;
	# 	};

	# 	gtk3.extraConfig = {
	# 		gtk-application-prefer-dark-theme = "0";
	# 	};

	# 	gtk4.extraConfig = {
	# 		gtk-application-prefer-dark-theme = "0";
	# 	};
	# };
}
