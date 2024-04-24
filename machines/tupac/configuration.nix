{ config, lib, pkgs, ... }:

# The Nix Confituration of TUPAC system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	networking.hostName = "tupac"; # Set Hostname

	# Plymouth
		boot.plymouth.enable = true;

	# Enable the X11 windowing system.
		services.xserver.enable = true;

		# Set layout
		services.xserver = {
			layout = "us";
			xkbVariant = "";
		};

	# Enable GNOME
		services.xserver.displayManager.gdm.enable = true;
		services.xserver.desktopManager.gnome.enable = true;

	# Flatpak
		services.flatpak.enable = true;

	# Networking
		networking.networkmanager.enable = true; # Enable Networking via network-manager

	# Printing
		services.printing.enable = true; # enable CUPS the deamon for printing

	# Non-Free
		hardware.enableRedistributableFirmware = true; # Neccesary Evil :(

	# KDE-connect
		programs.kdeconnect.enable = true;
		programs.kdeconnect.package = mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect; # Uses KDE thing by default which doesn't work on GNOME where we need gsconnect

	# Steam
		programs.steam = {
			enable = true;
			remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
		};

	# Tor
		services.tor = {
			enable = true; # Use Tor
			client.enable = true; # Provides Port 9050 with gateway to Tor
			relay.enable = true; # Work as a relay to obstruct network sniffing
		};

	# BinFMT - Enable seemless VM-based cross-compilation
		boot.binfmt.emulatedSystems = [
			"aarch64-linux"
			"riscv64-linux"
			"armv7l-linux"
		];

	# Waydroid
		virtualisation.waydroid.enable = true;

	# SSH
		services.openssh.enable = true;
		services.tor.relay.onionServices."hiddenSSH".map = [ 22 ]; # Hidden SSH

	# Firewall
		networking.firewall.enable = mkForce true; # Enforce FireWall

	# Auto-Upgrade
		system.autoUpgrade.enable = true;
		system.autoUpgrade.flake = "github:kreyren/nixos-config#tupac";
}
