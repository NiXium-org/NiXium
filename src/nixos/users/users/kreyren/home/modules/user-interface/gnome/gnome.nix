{ lib, pkgs, config, nixosConfig, ... }:

# TODO(Krey): This file is an un-manageable mindfuck that needs rewrite

# Use `$ dconf dump /` to get these
# dconf2nix, can be used to make this process easier -- https://github.com/gvolpe/dconf2nix

let
	inherit (lib) mkForce mkIf mkMerge;
	inherit (lib.hm.gvariant) mkTuple;
	flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${pkgs.flameshot}/bin/flameshot gui";
in mkIf nixosConfig.services.xserver.desktopManager.gnome.enable {
	config = mkMerge [
	# Gnome-version specific
		{
			"47.0.1" = {
				dconf.settings."org/gnome/desktop/interface".accent-color = "purple"; # Set Accent Color
			};
		}.${pkgs.gnome-session.version}

	# Common Configuration across multiple GNOME releases
		{
			dconf.settings = {
				"org/gnome/desktop/interface" = {
					color-scheme = "prefer-dark";
					gtk-theme = "adw-gtk3-dark";

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

				# Set up Proxy
					# TODO(Krey): Move this into a VPN/PAC setup?
					"system/proxy" = {
						mode = "auto";
						autoconfig-url = "file://${config.home.homeDirectory}/.config/proxy.pac";
					};

				# Bottles
					# TODO(Krey): This should be in bottle's own file, but which one?
					"com/usebottles/bottles" = {
						auto-close-bottles = true;
						release-candidate = true;
						experiments-sandbox = true;
						steam-proton-support = true;
					};

				# Keyboard Input Adjustments
					"org/gnome/desktop/input-sources" = {
						shob-all-sources = true;
						sources = [
							(mkTuple [ "xkb" "us" ]) # Standard US Keyboard
							(mkTuple [ "xkb" "cz+qwerty" ]) # Standard Czech Keyboard
						];
						xkb-options = [ "terminate:ctrl_alt_bksp" ];
					};
			};
		}
	];
}
