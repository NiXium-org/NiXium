{ config, pkgs, unstable, lib, ... }:

{
	home.stateVersion = "23.05";

	gtk.enable = true;

	programs.alacritty.enable = true; # Rust-based Video-accelarated terminal
	programs.bash.enable = true;
	programs.direnv.enable = true; # To manage git repositories
	programs.git.enable = true; # Generic use only
	programs.firefox.enable = true;
	programs.vim.enable = true;
	programs.vscode.enable = true;

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"vscode"
	];

	home.packages = [
		pkgs.keepassxc
		pkgs.cura
		# pkgs.prusa-slicer
		# pkgs.fractal
		pkgs.qbittorrent
		pkgs.stremio
		pkgs.android-tools
		pkgs.picocom
		pkgs.bottles
		# pkgs.kicad # Takes ages to build
		pkgs.mtr
		# nix-software-center.nix-software-center
		# pkgs.colobot
		pkgs.nix-index
		pkgs.tealdeer
		# pkgs.ventoy-full

		pkgs.sc-controller
		pkgs.freetube
		pkgs.hexchat
		pkgs.monero-gui
		pkgs.nextcloud-client
		pkgs.endeavour
		pkgs.dialect
		pkgs.freecad
		pkgs.airshipper
		pkgs.protonmail-bridge
			# FIXME(Krey): Blocked by https://github.com/emersion/hydroxide/issues/235
			#hydroxide
		pkgs.gimp # Generic use only
		pkgs.kooha

		# Gnome extensions
		pkgs.gnomeExtensions.removable-drive-menu
		pkgs.gnomeExtensions.vitals
		pkgs.gnomeExtensions.blur-my-shell
		pkgs.gnomeExtensions.gsconnect
		pkgs.gnomeExtensions.custom-accent-colors
		pkgs.gnomeExtensions.desktop-cube
		pkgs.gnomeExtensions.burn-my-windows
		pkgs.gnomeExtensions.caffeine

		#nerdfonts
		# NOTE(Krey): This was recommended, because nerdfonts might have issues with rendering -- https://github.com/TanvirOnGH/nix-config/blob/nix%2Bhome-manager/desktop/customization/font.nix#L4-L39
		(pkgs.nerdfonts.override {
			fonts = [
				"Noto"
				"FiraCode"
			];
		})
	];

	# GNOME Extensions
	dconf.settings = {
		"org/gnome/shell" = {
			disable-user-extensions = false;

			# The extension names can be found through `$ gnome-extensions list`
			enabled-extensions = [
				"Vitals@CoreCoding.com"
				"drive-menu@gnome-shell-extensions.gcampax.github.com"
				"blur-my-shell@aunetx"
				"user-theme@gnome-shell-extensions.gcampax.github.com"
				"gsconnect@andyholmes.github.io"
				"custom-accent-colors@demiskp"
				"desktop-cube@schneegans.github.com"
			];

			disabled-extensions = [];
		};
	};
}
