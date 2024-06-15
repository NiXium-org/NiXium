{ pkgs, lib, unstable, aagl, staging-next, ... }:

{
	home.stateVersion = "24.05";

	gtk.enable = true;

	home.impermanence.enable = true;

	programs.alacritty.enable = true; # Rust-based Video-accelarated terminal
	programs.bash.enable = true;
	programs.direnv.enable = true; # To manage git repositories
	programs.git.enable = true; # Generic use only
	programs.gpg.enable = true;
	programs.firefox.enable = true;
	programs.vim.enable = true;
	programs.vscode.enable = true;

	services.gpg-agent.enable = true;

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"vscode"
	];

	home.packages = [
		pkgs.simplex-chat-desktop
		pkgs.session-desktop
		pkgs.keepassxc
		pkgs.cura
		pkgs.prusa-slicer
		unstable.fractal
		pkgs.qbittorrent
		unstable.stremio
		pkgs.youtube-dl
		pkgs.yt-dlp
		pkgs.android-tools
		pkgs.picocom
		pkgs.bottles
		pkgs.kicad
		pkgs.mtr
		# nix-software-center.nix-software-center
		# pkgs.colobot
		pkgs.nix-index
		pkgs.tealdeer
		# pkgs.ventoy-full

		# FIXME_QA(Krey): Figure out how to enable this only on GNOME
		# FIXME(Krey): on NixOS 23.11 it's pinentry-gnome, but on unstable it's pinentry-gnome3
		pkgs.pinentry-gnome3

		(pkgs.brave.override {
			# NOTE(Krey): Using system-wide tor which is interfiering with the brave's browsing as non-tor browsing has tor and tor browser goes through 2 Tors so this fixes it
			commandLineArgs = "--no-proxy-server";
		})

		pkgs.sc-controller
		pkgs.freetube
		pkgs.hexchat
		pkgs.monero-gui
		pkgs.nextcloud-client
		pkgs.endeavour
		pkgs.dialect
		pkgs.freecad
		pkgs.airshipper
		pkgs.mindustry
		pkgs.protonmail-bridge
			# FIXME(Krey): Blocked by https://github.com/emersion/hydroxide/issues/235
			#hydroxide
		# pkgs.gaphor
		pkgs.tor-browser-bundle-bin
		pkgs.gimp # Generic use only
		pkgs.kooha

		# An Anime Game
		aagl.anime-game-launcher

		# Gnome extensions
		pkgs.gnomeExtensions.removable-drive-menu
		pkgs.gnomeExtensions.vitals
		pkgs.gnomeExtensions.blur-my-shell
		pkgs.gnomeExtensions.gsconnect
		pkgs.gnomeExtensions.custom-accent-colors

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
		# Set power management for a scenario where user is logged-in
		"org/gnome/settings-daemon/plugins/power" = {
			power-button-action = "hibernate";
			sleep-inactive-ac-timeout = 600; # 60*10=600 Seconds -> 10 Minutes
			sleep-inactive-ac-type = "suspend";
		};

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
				"caffeine@patapon.info"
			];

			disabled-extensions = [];
		};
	};
}
