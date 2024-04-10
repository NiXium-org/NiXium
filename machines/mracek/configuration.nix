{ lib, config, ... }:

# The Nix Confituration of MRACEK system

let
	inherit (lib) mkForce mkIf;
in {
	networking.hostName = "mracek";

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
			users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ]; # Allow root access for all systems

		# Vikunja
			# FIXME-PRIVACY(Krey): Force Vikunja to use the tor proxy for clearnet requests https://unix.stackexchange.com/questions/501623/forward-all-traffic-to-a-socks5-proxy-port/501713#501713
			# FIXME-QA(Krey): Current vikunja doesn't know how to resolve HTTP/S requests so it has a hard dependency on nginx and alike.. Was told that this will be addressed in next release
		services.vikunja.enable = true;
			# NOTE(Krey): Currently vikunja has a hard dependency on nginx, next version is expected to be independent
			# services.tor.relay.onionServices."hiddenVikunja".map = mkIf config.services.vikunja.enable [ config.services.vikunja.port ]; # Set up Onionized Vikunja
			services.tor.relay.onionServices."hiddenVikunja".map = mkIf config.services.vikunja.enable [ 80 ]; # Set up Onionized Vikunja

		# Monero node
			services.monero.enable = true;
			# Use pruned blockhain and tor for proxy
			services.monero.extraConfig = ''
				prune-blockchain=1
				proxy=127.0.0.1:9050
			'';
				services.tor.relay.onionServices."hiddenMonero".map = mkIf config.services.monero.enable [ config.services.monero.rpc.port ]; # Set up Onionized Monero Node

		# Vault Warden
			#services.vaultwarden.enable = false; # Testing..
			#services.tor.relay.onionServices."hiddenWarden".map = mkIf config.services.vaultwarden.enable [ config.services.vaultwarden.config.ROCKET_PORT ]; # Deploy an onion service for the vault warden

		# Mumble
			services.murmur.enable = true;
				services.tor.relay.onionServices."hiddenMurmur".map = mkIf config.services.murmur.enable [ config.services.murmur.port ]; # Set up Onionized Murmur

		# Gitea
			services.gitea.enable = true;
				# NOTE(Krey): It's declared this way so that we don't have to use `url.onion:3000` as the web browsers will default to using port 80 for HTTP and port 443 for HTTPS
				services.tor.relay.onionServices."hiddenGitea".map = mkIf config.services.gitea.enable [{ port = 80; target = { port = config.services.gitea.settings.server.HTTP_PORT; }; }]; # Set up Onionized Gitea

		# Firewall
			networking.firewall.enable = mkForce true; # Enforce FireWall
			# networking.firewall.allowedTCPPorts = [ ... ];
			# networking.firewall.allowedUDPPorts = [ ... ];

	## Configuration ##
		services.logind.lidSwitchExternalPower = "lock"; # Lock the system on closing the lid when on external power instead of suspend/hibernation

		# Proxy
		networking.proxy.default = "socks5://127.0.0.1:9050";
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

	# Auto-Upgrade
		system.autoUpgrade.enable = false;
		system.autoUpgrade.flake = "github:kreyren/nixos-config#mracek";
}
