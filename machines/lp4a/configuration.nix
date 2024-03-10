{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of PELAGUS system

# SECURITY(Krey): Uses Ryzen 5 1600 which is affected by hardware vulnerabilities! SMT prohibited

let
	inherit (lib)
		mkIf
		mkForce;
in {
	networking.hostName = "lp4a";

	# Desktop Environment
		# GNOME
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
		services.openssh.enable = true;
			services.tor.relay.onionServices."hiddenSSH".map = [ 22 ]; # Hidden SSH

		services.tor.enable = true;
		services.tor.client.enable = true;
		services.tor.relay = {
			enable = true;
			role = "relay"; # Expected to be set on-demand per device
		};

	# Misc
		environment.defaultPackages = mkForce []; # Get rid of default packages for minimalism

	# Security
		# Sudo
		security.sudo.enable = mkForce false; # Get rid of Sude
		security.sudo-rs.enable = true; # Get sudo in rust
		security.sudo-rs.execWheelOnly = true; # Only let wheels to use sudo to avoid attack vectors such as CVE-2021-3156

		# ClamAV
		services.clamav.daemon.enable = true;
		services.clamav.updater.enable = true; # Update virus definitions?

	# Virtualization
		# virtualisation.libvirtd.enable = true;

	# BinFMT - Enable seemless VM-based cross-compilation
		# boot.binfmt.emulatedSystems = [
		# 	"aarch64-linux"
		# 	"x86_64-linux"
		# ];

	# CCache
		programs.ccache.enable = true;
		programs.ccache.packageNames = [
				"linuxPackages_testing"
				"linux_testing"
		];

	# Auto-Upgrade
		system.autoUpgrade.enable = false; # In Development, do not enable until it's stabilized enough
		system.autoUpgrade.flake = "github:kreyren/nixos-config#lp4a";
}
