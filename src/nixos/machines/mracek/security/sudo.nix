{ lib, pkgs, ... }:

# Security enforcement of root elevation to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	# No non-root users expected on the system beyond nix-managed services
	security.sudo.enable = mkForce false;
	security.sudo-rs.enable = mkForce false;
}
