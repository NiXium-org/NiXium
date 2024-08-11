{ config, lib, ... }:

# Setup of MRACEK

let
	inherit (lib) mkIf;
in {
	networking.hostName = "tsetan";

	boot.impermanence.enable = true; # Use impermanence

	boot.plymouth.enable = true;

	nix.distributedBuilds = true; # Perform distributed builds

	services.openssh.enable = true;
	services.tor.enable = true;

	age.secrets.tsvetan-ssh-ed25519-private.file = ../secrets/tsvetan-ssh-ed25519-private.age; # Declare private key

	nixpkgs.hostPlatform = "aarch64-linux";
}
