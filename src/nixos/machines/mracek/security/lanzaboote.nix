{ config, lib, ... }:

# Enables Secure Boot through lanzaboote on MRACEK system

let
	inherit (lib) mkForce mkIf;
in mkIf config.boot.lanzaboote.enable {
	boot.loader.systemd-boot.enable = mkForce false; # Lanzeboote uses it's own module and requires this disabled
	boot.loader.efi.canTouchEfiVariables = mkForce true;

	boot.lanzaboote = {
		pkiBundle = "/etc/secureboot";
	};

	# FIXME(Krey): if impermenance is enable then -> Persist lanzaboote files
}
