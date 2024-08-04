{ config, pkgs, lib, aagl, aagl-unstable, unstable, kreyren, ... }:

let
	inherit (lib) mkIf;
in {
	gtk.enable = true;

	home.impermanence.enable = true;

	programs.alacritty.enable = false; # Rust-based Hardware-accelarated terminal
	programs.kitty.enable = true; # Alternative Rust-based Hardware-accelarated terminal for testing, potentially superrior to alacritty
	programs.bash.enable = true;
	programs.starship.enable = true;
	programs.direnv.enable = true; # To manage git repositories
	programs.git.enable = true; # Generic use only
	programs.gpg.enable = true;
	programs.firefox.enable = true;
	programs.vim.enable = true;
	programs.vscode.enable = true; # Generic use only

	services.gpg-agent.enable = (mkIf config.programs.gpg.enable true);

	nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
		"vscode"
		"etlegacy"
		"etlegacy-assets"
		"davinci-resolve"
		"discord"
	];

	home.packages = [
		# Use ProtonVPN for WebCord
		(pkgs.webcord.overrideAttrs (super: {
			postInstall = ''
				wrapProgram $out/bin/webcord \
					--append-flags "--proxy-server=socks5://127.0.0.1:25344"
			'';
		}))

		# PRIVACY(Krey): Temporary management with adjusted threat model used only as a fallback in case webcord fails in production
		(pkgs.discord.overrideAttrs (super: {
			postInstall = ''
				wrapProgram $out/bin/discord \
					--append-flags "--no-proxy-server"

				wrapProgram $out/bin/Discord \
					--append-flags "--no-proxy-server"
			'';
		}))

		pkgs.keepassxc
		# pkgs.cura # Broken: https://github.com/NixOS/nixpkgs/issues/186570
		pkgs.prusa-slicer
		unstable.fractal
		pkgs.qbittorrent
		pkgs.stremio
		pkgs.android-tools
		pkgs.picocom
		pkgs.bottles
		pkgs.kicad
		pkgs.mtr
		# nix-software-center.nix-software-center
		pkgs.colobot
		pkgs.nix-index
		pkgs.tealdeer
		# pkgs.ventoy-full
		pkgs.davinci-resolve
		pkgs.blender

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
		pkgs.helvum
		pkgs.etlegacy
		pkgs.mindustry
		#pkgs.protonmail-bridge
			# FIXME(Krey): Blocked by https://github.com/emersion/hydroxide/issues/235
			#hydroxide
		# pkgs.gaphor
		pkgs.tor-browser-bundle-bin
		pkgs.gimp # Generic use only
		pkgs.kooha

		# Session uses system proxy by default which breaks functionality
		(pkgs.session-desktop.overrideAttrs (super: {
			postInstall = ''
				wrapProgram $out/bin/session-desktop \
					--append-flags "--no-proxy-server"
			'';
		}))
		pkgs.element-desktop
		pkgs.simplex-chat-desktop

		# Gnome extensions
		pkgs.gnomeExtensions.removable-drive-menu
		pkgs.gnomeExtensions.vitals
		pkgs.gnomeExtensions.blur-my-shell
		pkgs.gnomeExtensions.gsconnect
		pkgs.gnomeExtensions.custom-accent-colors
		pkgs.gnomeExtensions.desktop-cube
		pkgs.gnomeExtensions.burn-my-windows
		pkgs.gnomeExtensions.caffeine

		# An Anime Game
		aagl.anime-game-launcher

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
				"caffeine@patapon.info"
			];

			disabled-extensions = [];
		};

		# System Monitor
		"org/gnome/gnome-system-monitor" = {
			show-dependencies = false;
			show-whose-processes= "user";
		};

		"org/gnome/gnome-system-monitor/disktreenew" = {
			col-6-visible = true;
			col-6-width = 0;
		};

		"org/gnome/shell/extensions/vitals" = {
			fixed-widths = true;
			hide-icons = false;
			hide-zeros = false;
			icon-style = 1;
			include-static-info = false;
			menu-centered = false;
			network-speed-format = 1;
			position-in-panel = 1;
			show-battery = true;
			show-gpu = true;
			update-time = 3;
			use-higher-precision = true;

			hot-sensors = [
				"_memory_usage_"
				"_system_load_1m_"
				"__temperature_avg__"
				"_temperature_gpu_"
				"_voltage_bat0_in0_"
				"__network-rx_max__"
				"__network-tx_max__"
				"_storage_free_"
			];
		};
	};
}
