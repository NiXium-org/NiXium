{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of SINNENFREUDE system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	networking.hostName = "sinnenfreude";

	nix.distributedBuilds = true; # Perform distributed builds

	boot.initrd.systemd.enable = true; # Enable systemd initrd

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Desktop Environment
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Plymouth
	# FIXME(Krey): Figure out how we want to use plymouth
	#boot.plymouth.enable = true;

	# WakeOnLan
	networking.interfaces.wlp13s0.wakeOnLan.enable = true; # Enable WakeOnLAN for WiFi

	# X-Server
	services.xserver.enable = true;
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
	services.flatpak.enable = true;
	services.xmrig.enable = false; # Need optimization to not affect workflow

	services.openssh.enable = true;
		services.tor.relay.onionServices."hiddenSSH".map = [ 22 ]; # Hidden SSH

	services.vikunja.enable = false;

  services.tor.enable = true;
  services.tor.client.enable = true;
	services.tor.relay = {
		enable = true;
		role = "relay"; # Expected to be set on-demand per device
	};

	# Run lact (AMD Overclocking utility)
	# FIXME-QA(Krey): Submit this to nixpkgs to clear up the space here
	systemd.services.lact-daemon = {
		enable = true;
		wantedBy = [ "multi-user.target" ];
		after = [ "network.target" ];
		description = "Generate unique SSH key for the distribute builds";
		script = ''
			${unstable.lact}/bin/lact daemon
		'';
	};

	programs.noisetorch.enable = true;

	programs.kdeconnect.enable = true;
		programs.kdeconnect.package = mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect; # Uses KDE thing by default which doesn't work on GNOME where we need gsconnect

	# Chromecast/Gnomecast experiment
	## * https://github.com/NixOS/nixpkgs/issues/49630
	# services.avahi.enable = true;
	# networking.firewall = {
	# 	allowedUDPPorts = [ 5353 ]; # For device discovery
	# 	allowedUDPPortRanges = [{ from = 32768; to = 61000; }]; # For Streaming
	# 	allowedTCPPorts = [ 8010 ];  # For gnomecast server
	# };

	services.logind.lidSwitchExternalPower = "lock"; # Lock the system on closing the lid when on external power

	# Virtualization
	virtualisation.libvirtd.enable = true;
	virtualisation.docker.enable = true;

	# BinFMT - Enable seemless VM-based cross-compilation
	boot.binfmt.emulatedSystems = [
		"aarch64-linux"
		"riscv64-linux"
	];

	# CCache
		programs.ccache.enable = true;
		programs.ccache.packageNames = [
			# CCache Linux for tsvetan
				#"linux"
				#"linuxPackages"
				# "linuxKernel.kernels.linux"

				# "linux_latest"
				#"linuxPackages_latest"
				# "linuxKernel.kernels.linux_latest"

				"linux_testing"
				"linuxPackages_testing"
				#"linuxKernel.kernels.linux_testing"
		];

	# Auto-Upgrade
	system.autoUpgrade.enable = false;
	system.autoUpgrade.flake = "github:kreyren/nixos-config#sinnenfreude";
}
