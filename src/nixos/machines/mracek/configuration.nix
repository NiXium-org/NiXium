{ lib, config, ... }:

# The Nix Confituration of MRACEK system

let
	inherit (lib) mkForce mkIf;
in {
	services.gitea.enable = true;
	services.monero.enable = true;
	services.murmur.enable = true;
	services.navidrome.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;
	# services.vaultwarden.enable = false; # Testing..
	services.vikunja.enable = true; # Vikunja

	## Configuration

	# Allow root access for all systems to KREYREN
	users.users.root.openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ];
}
