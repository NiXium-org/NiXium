{ config, lib, ... }:

# Setup of MRACEK

let
	inherit (lib) mkIf;
in {
	networking.hostName = "tsvetan";

	boot.impermanence.enable = true; # Use impermanence

	# FIXME(Krey): Fails to deploy during initrd and then breaks GNOME deployment
	boot.plymouth.enable = false;

	nix.distributedBuilds = true; # Perform distributed builds

	services.openssh.enable = true;
	services.tor.enable = true;

	# Desktop Environment
	# services.xserver.enable = true;
	# services.xserver.displayManager.gdm.enable = true;
	# services.xserver.desktopManager.gnome.enable = true;
	# 	programs.dconf.enable = true; # Needed for home-manager to not fail deployment (https://github.com/nix-community/home-manager/issues/3113)

		users.users.root.openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" # Allow root access for the Super Administrator (KREYREN)
	];

	age.secrets.tsvetan-ssh-ed25519-private.file = ../secrets/tsvetan-ssh-ed25519-private.age; # Declare private key/

	nixpkgs.hostPlatform = "aarch64-linux";
}
