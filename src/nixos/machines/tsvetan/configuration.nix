{ pkgs, config, unstable, crossPkgs, inputs, lib, ... }:

# The Nix Configuration of TSVETAN system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	networking.hostName = "tsvetan";

	nix.distributedBuilds = true; # Do distributed builds

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;
	# services.xserver.desktopManager.xfce.enable = true;
	# services.xserver.desktopManager.xterm.enable = true;
	# services.xserver.displayManager.defaultSession = "xfce";

	# X-Server
	services.xserver = {
		layout = "us"; # Use 'eu' ?
		xkbVariant = "";
	};

	# Firewall
	networking.firewall.enable = mkForce true; # Enforce FireWall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];

	# Services
	services.lokinet.enable = false; # To Be Figured Out How To Use It Sanely
	# services.flatpak.enable = true;
	services.xmrig.enable = false; # Need optimization to not affect workflow

	services.openssh.enable = true;
		services.tor.relay.onionServices."hiddenSSH".map = [ 22 ]; # Hidden SSH

	services.tor.enable = true;
	services.tor.client.enable = true;
	services.tor.relay = {
		enable = true;
		role = "relay"; # Expected to be set on-demand per device
	};

	programs.noisetorch.enable = true;

	programs.kdeconnect.enable = true;
		programs.kdeconnect.package = mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect; # Uses KDE thing by default which doesn't work on GNOME where we need gsconnect

	# Virtualization
		# virtualisation.libvirtd.enable = true;
		# virtualisation.docker.enable = true;
		virtualisation.waydroid.enable = true;

	# BinFMT - Enable seemless VM-based cross-compilation
	boot.binfmt.emulatedSystems = [
		"x86_64-linux"
		"riscv64-linux"
	];

	environment.systemPackages = [
		(mkIf config.services.xserver.desktopManager.gnome.enable pkgs.pinentry-gnome)
	];

	# CCache
	programs.ccache.enable = true;
	programs.ccache.packageNames = [
		# CCache Linux for tsvetan
			"linuxPackages_testing"
			"linux_testing"
	];

  zramSwap.enable = true; # Experiment

	# Auto-Upgrade
	system.autoUpgrade.enable = false; # Causes issues
	system.autoUpgrade.flake = "github:kreyren/nixos-config#tsvetan";
}
