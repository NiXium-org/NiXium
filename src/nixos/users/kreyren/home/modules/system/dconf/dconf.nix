{ lib, pkgs, ... }:

let
	inherit (lib) mkForce;
	inherit (lib.hm.gvariant) mkTuple;
  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${pkgs.flameshot}/bin/flameshot gui";
in {
	# Use `$ dconf dump /` to get these
	# dconf2nix, can be used to make this process easier -- https://github.com/gvolpe/dconf2nix
	dconf.settings = {
		"org/gnome/desktop/interface" = {
			color-scheme = "prefer-dark";
			gtk-theme = mkForce "adw-gtk3-dark";
			enable-hot-corners = true;
			clock-show-seconds = true;
			show-battery-percentage = true;
		};

		"org/gnome/mutter" = {
			dynamic-workspaces=true;
			workspaces-only-on-primary=false;
			experimental-features = [
				# Fractional Scaling
				"scale-monitor-framebuffer"
			];
		};

		"org/gnome/desktop/peripherals/touchpad" = {
			edge-scrolling-enabled = false;
			natural-scroll = true;
			two-finger-scrolling-enabled = true;
		};

		# FIXME(Krey): This doesn't work, figure out why
		# "org/gnome/Weather" = {
		# 	locations = "[<(uint32 2, <('Brno', 'LKTB', true, [(0.857829327355213, 0.291469985083053)], [(0.85870199198121022, 0.29030642643062599)])>)>]";
		# };
		"org/gnome/shell/weather" = {
			automatic-location = true;
			#locations = "[<(uint32 2, <('Brno', 'LKTB', true, [(0.857829327355213, 0.291469985083053)], [(0.85870199198121022, 0.29030642643062599)])>)>]";
		};

		# Set the weather app in Kelvin #KelvinGang
		"org/gnome/GWeather4" = {
			temperature-unit = "kelvin";
		};

		# # Set up Proxy
		# "system/proxy" = {
		# 	mode = "manual";
		# };
		# "system/proxy/socks" = {
		# 	host = "127.0.0.1";
		# 	port = 9050;
		# };

		# Bottles
		"com/usebottles/bottles" = {
			auto-close-bottles = true;
			release-candidate = true;
			experiments-sandbox = true;
			steam-proton-support = true;
		};

		# Over Amplification
		"org/gnome/desktop/sound" = {
			allow-volume-above-100-percent = true;
		};

		# Button Modifier for resizing with mouse
		"org/gnome/desktop/wm/preferences" = {
			mouse-button-modifier = "<Alt>";
			resize-with-right-button = true;
		};

		# Keybinds -- https://discourse.nixos.org/t/nixos-options-to-configure-gnome-keyboard-shortcuts/7275/4
		"org/gnome/shell/keybinds" = {
			## To fix conflict with keybinding
			# show-screenshot-ui = [ "<Control>Print" ];
			show-screenshot-ui = [ ];
		};

		"org/gnome/settings-daemon/plugins/media-keys" = {
			custom-keybindings = [
				"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
				"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
				"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
				"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
				"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/"
			];
		};

		## Terminal
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
			name = "Open Terminal";
			command = "kitty";
			binding = "<Super>Return";
		};

		## Web Browser
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
			name = "Open Web Browser";
			command = "firefox";
			binding = "<Super>t";
		};

		## File Browser
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
			name = "Open File Browser";
			command = "nautilus";
			binding = "<Super>e";
		};

		## xkill
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
			name = "xkill";
			command = "xkill";
			binding = "<Control>Escape";
		};

		## Flameshot GUI
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
			name = "Flameshot GUI";
			command = "${flameshot-gui}/bin/flameshot-gui";
			binding = "Print";
		};

		# Background
		"org/gnome/desktop/background" = {
			#picture-uri="${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-l.svg";
			picture-uri ="${./wallpaper.jpeg}";
			#picture-uri-dark="${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-d.svg";
			picture-uri-dark ="${./wallpaper.jpeg}";
		};
		"org/gnome/desktop/screensaver" = {
			picture-uri ="${./lockscreen.jpg}";
			#picture-uri = "${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-l.svg";
		};

		"org/gnome/desktop/input-sources" = {
			shob-all-sources = true;
			sources = [
				(mkTuple [ "xkb" "us" ])
				(mkTuple [ "xkb" "cz+qwerty" ])
			];
			xkb-options = [ "terminate:ctrl_alt_bksp" ];
		};
	};
}
