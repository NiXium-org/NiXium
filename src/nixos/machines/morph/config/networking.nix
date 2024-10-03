{ lib, ... }:

# Networking Management of MORPH

let
	inherit (lib) mkForce;
in {
	networking.interfaces."enp6s0" = {
		useDHCP = true; # Use DHCP on the main network interface
		wakeOnLan = {
			enable = true; # Enable WOL
			policy = [
				"magic" # Wake on receipt of a magic packet
			];
		};
	};

	# Always use network manager for convinience
	# FIXME-QA(Krey): Set to false by `/nixos/modules/services/networking/networkmanager.nix`, better management needed
	networking.networkmanager.enable = mkForce true;
}
