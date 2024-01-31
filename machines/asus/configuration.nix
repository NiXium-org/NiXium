{ lib, config, ... }:

# The Nix Confituration of ASUS system

let
	inherit (lib) mkForce mkIf;
in {
	networking.hostName = "asus";

	## Services ##
		# Tor
		services.tor = {
			enable = true; # Use Tor
			client.enable = true; # Provides Port 9050 with gateway to Tor
			relay.enable = true; # Work as a relay to obstruct network sniffing
		};

		# OpenSSH
		services.openssh.enable = true;
			services.tor.relay.onionServices."hiddenSSH".map = mkIf config.services.tor.enable config.services.openssh.ports; # Provide hidden SSH

			users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ]; # Allow root access for KREYREN

		# Vikunja
		## FIXME-PRIVACY(Krey): Force Vikunja to use the tor proxy for clearnet requests https://unix.stackexchange.com/questions/501623/forward-all-traffic-to-a-socks5-proxy-port/501713#501713
		services.vikunja.enable = true;
			# services.tor.relay.onionServices."hiddenVikunja".map = mkIf config.services.vikunja.enable [ config.services.vikunja.port ]; # Set up Onionized Vikunja
			services.tor.relay.onionServices."hiddenVikunja".map = mkIf config.services.vikunja.enable [ 80 ]; # Set up Onionized Vikunja

		# Firewall
		networking.firewall.enable = mkForce true; # Enforce FireWall
		# networking.firewall.allowedTCPPorts = [ ... ];
		# networking.firewall.allowedUDPPorts = [ ... ];


	## Configuration ##
		services.logind.lidSwitchExternalPower = "lock"; # Lock the system on closing the lid when on external power instead of suspend/hibernation

		# Proxy
		networking.proxy.default = "socks5://127.0.0.1:9050/";
		networking.proxy.noProxy = "127.0.0.1,localhost";

	## Virtualization ##
		# LibVirt
		virtualisation.libvirtd.enable = false;

		# Docker
		virtualisation.docker.enable = false;

		# BinFMT - Enable seemless VM-based cross-compilation
		boot.binfmt.emulatedSystems = [
			"aarch64-linux"
			"riscv64-linux"
		];
}
