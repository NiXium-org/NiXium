{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of PELAGUS system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	boot.plymouth.enable = true;

	services.pcscd.enable = true; # Smart Card Daemon
	services.sunshine.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;
	# services.i2pd.enable = true;
	services.usbmuxd.enable = true; # iPhone shits
	services.clamav.daemon.enable = true;
		services.clamav.updater.enable = true; # Update virus definitions?

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	nix.distributedBuilds = true; # Perform distributed builds

	### --- ###

	# Firewall
	networking.firewall.enable = mkForce true; # Enforce FireWall
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];

	environment.defaultPackages = mkForce []; # Get rid of default packages for minimalism

	programs.noisetorch.enable = true;

	programs.kdeconnect.enable = true;
		programs.kdeconnect.package = mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect; # Uses KDE thing by default which doesn't work on GNOME where we need gsconnect

	# Security
		# Sudo
		security.sudo.enable = mkForce false; # Get rid of Sude
		security.sudo-rs.enable = true; # Get sudo in rust
		security.sudo-rs.execWheelOnly = true; # Only let wheels to use sudo to avoid attack vectors such as CVE-2021-3156

	# Virtualization
	virtualisation.libvirtd.enable = true;
	virtualisation.docker.enable = true;
	virtualisation.waydroid.enable = true;

	# BinFMT - Enable seemless VM-based cross-compilation
	boot.binfmt.emulatedSystems = [
		"aarch64-linux"
		"riscv64-linux"
		"armv7l-linux"
	];

	# CCache
	programs.ccache.enable = true;
	programs.ccache.packageNames = [
		# CCache Linux for tsvetan
			"linuxPackages_testing"
			"linux_testing"
	];

	# Auto-Upgrade
	system.autoUpgrade.enable = false;
	system.autoUpgrade.flake = "github:kreyren/nixos-config#pelagus";
}
