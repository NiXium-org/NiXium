{ lib, ... }:

# Networking Management of TSVETAN

let
	inherit (lib) mkForce;
in {
	# FIXME-QA(Krey): Enable DHCP only on specified adapters
	# FIXME-QA(Krey): Set to false by `/nixos/modules/services/networking/networkmanager.nix`, better management needed
	networking.useDHCP = mkForce true; # Use DHCP on all adapters
	# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

	# Always use network manager for convinience
	# FIXME-QA(Krey): Set to false by `/nixos/modules/services/networking/networkmanager.nix`, better management needed
	# networking.networkmanager.enable = mkForce true;

	networking.wireless.enable = true;
	networking.wireless.userControlled.enable = true; # Allow controlling wpa_supplicant via wpa_cli command
	systemd.services.wpa_supplicant.wantedBy = [ "multi-user.target" ]; # Start wpa_supplicant service on startup
}
