{ config, lib, ... }:

# Setup of TSVETAN

let
	inherit (lib) mkIf;
in {
	networking.hostName = "tsvetan";

	boot.impermanence.enable = true; # Use impermanence

	boot.plymouth.enable = true;

	nix.distributedBuilds = true; # Perform distributed builds

	services.openssh.enable = true;
	services.tor.enable = true;

	nixpkgs.hostPlatform = "aarch64-linux";
}
