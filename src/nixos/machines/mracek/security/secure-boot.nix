{ lib, pkgs, ... }:

# Security enforcement of secure-boot to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	boot.lanzaboote.enable = mkForce true; # Enforce secure boot

	security.tpm2.enable = mkForce true; # Trusted Platform Module 2 support
}
