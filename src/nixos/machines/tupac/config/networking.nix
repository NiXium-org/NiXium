{ lib, ... }:

# Networking management of TUPAC

let
	inherit (lib) mkForce;
in {
	networking.networkmanager.enable = mkForce true; # Always use NetworkManager over the default

	networking.useDHCP = mkForce true; # Use DHCP on all adapters
}
