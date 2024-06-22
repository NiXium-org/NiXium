{ lib, pkgs, ... }:

let
	inherit (lib) mkForce;
	inherit (lib.hm.gvariant) mkTuple;
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
		};

		"org/gnome/desktop/peripherals/touchpad" = {
			edge-scrolling-enabled = false;
			natural-scroll = true;
			two-finger-scrolling-enabled = true;
		};

		"org/gnome/shell/weather" = {
			automatic-location = true;
		};

		# Set the weather app in Kelvin #KelvinGang
		"org/gnome/GWeather4" = {
			temperature-unit = "kelvin";
		};

		# Set up Proxy
		"system/proxy" = {
			mode = "manual";
		};
		"system/proxy/socks" = {
			host = "127.0.0.1";
			port = 9050;
		};

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

		# Power
		"org/gnome/settings-daemon/plugins/power" = {
			power-button-action = "hibernate"; # "nothing"
			sleep-inactive-ac-type = "nothing";
		};

		# Keybinds -- https://discourse.nixos.org/t/nixos-options-to-configure-gnome-keyboard-shortcuts/7275/4
		"org/gnome/shell/keybinds" = {
			## To fix conflict with keybinding
			show-screenshot-ui = [ "<Control>Print" ];
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
			command = "${pkgs.alacritty}/bin/alacritty";
			binding = "<Super>Return";
		};

		## Web Browser
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
			name = "Open Web Browser";
			command = "${pkgs.firefox}/bin/firefox";
			binding = "<Super>t";
		};

		## File Browser
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
			name = "Open File Browser";
			command = "${pkgs.gnome.nautilus}/bin/nautilus";
			binding = "<Super>e";
		};

		## xkill`
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
			name = "xkill";
			command = "${pkgs.xorg.xkill}/bin/xkill";
			binding = "<Control>Escape";
		};

		## Flameshot GUI
		"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
			name = "Flameshot GUI";
			command = "${pkgs.flameshot}/bin/flameshot gui";
			binding = "Print";
		};

		# Background
		"org/gnome/desktop/background" = {
			#picture-uri="${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-l.svg";
			picture-uri ="./wallpaper.jpeg";
			#picture-uri-dark="${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-d.svg";
			picture-uri-dark ="./wallpaper.jpeg";
		};
		"org/gnome/desktop/screensaver" = {
			picture-uri ="./wallpaper.jpeg";
			#picture-uri = "${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/blobs-l.svg";
		};

		"org/gnome/desktop/input-sources" = {
			shob-all-sources = true;
			sources = [
				(mkTuple [ "xkb" "us" ])
				(mkTuple [ "xkb" "cz" ])
			];
			xkb-options = [ "terminate:ctrl_alt_bksp" ];
		};

		# Extension: Vitals
		"org/gnome/shell/extensions/vitals" = {
			hot-sensors = [
				"_memory_usage_"
				"_system_load_1m_"
				"__network-rx_max__"
				"__temperature_avg__"
			];
		};

		# Extension: Custom Accent Colors
		## FIXME-QA(Krey): Apply this only when custom accent colors is enabled
		"org/gnome/shell/extensions/custom-accent-colors" = {
			accent-color = "green";
			theme-flatpak = true;
			theme-gtk3 = true;
			theme-shell = true;
		};

		"org/gnome/shell/extensions/user-theme" = {
			name = "Custom-Accent-Colors";
		};
	};
}
