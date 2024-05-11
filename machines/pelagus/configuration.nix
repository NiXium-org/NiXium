{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of PELAGUS system

# SECURITY(Krey): Uses Ryzen 5 1600 which is affected by hardware vulnerabilities! SMT prohibited

let
	inherit (lib)
		mkIf
		mkForce;
in {
	networking.hostName = "pelagus";

	nix.distributedBuilds = true; # Perform distributed builds

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Desktop Environment
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Plymouth
	# FIXME(Krey): Figure out how we want to use plymouth
	#boot.plymouth.enable = true;

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

	services.tor.enable = true;
	services.tor.client.enable = true;
	services.tor.relay = {
		enable = true;
		role = "relay"; # Expected to be set on-demand per device
	};

	# I2P
	services.i2pd.enable = true; # Enable the daemon
	services.i2pd.package = unstable.i2pd;
	services.i2pd.websocket.enable = true; # Enable web socket
	services.i2pd.proto.socksProxy.enable = true;
	services.i2pd.proto.sam.enable = true;

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

	environment.defaultPackages = mkForce []; # Get rid of default packages for minimalism

	programs.noisetorch.enable = true;

	programs.kdeconnect.enable = true;
		programs.kdeconnect.package = mkIf config.services.xserver.desktopManager.gnome.enable pkgs.gnomeExtensions.gsconnect; # Uses KDE thing by default which doesn't work on GNOME where we need gsconnect

	# iPhone shits
	services.usbmuxd.enable = true;

	environment.systemPackages = with pkgs; [
		libimobiledevice
		ifuse # optional, to mount using 'ifuse'
	];

	# Smart Card Daemon
	services.pcscd.enable = true;

	# Security
		# Sudo
		security.sudo.enable = mkForce false; # Get rid of Sude
		security.sudo-rs.enable = true; # Get sudo in rust
		security.sudo-rs.execWheelOnly = true; # Only let wheels to use sudo to avoid attack vectors such as CVE-2021-3156

	# ClamAV
	services.clamav.daemon.enable = true;
	services.clamav.updater.enable = true; # Update virus definitions?

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
