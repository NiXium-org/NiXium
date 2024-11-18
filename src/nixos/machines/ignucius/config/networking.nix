{ lib, ... }:

# Networking Management of IGNUCIUS

let
	inherit (lib) mkForce;
in {
	# FIXME-QA(Krey): Set to false by `/nixos/modules/services/networking/networkmanager.nix`, better management needed
	networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;
	# networking.interfaces.wwp0s29u1u4i6.useDHCP = lib.mkDefault true;

	# Always use network manager for convinience
	# FIXME-QA(Krey): Set to false by `/nixos/modules/services/networking/networkmanager.nix`, better management needed
	networking.networkmanager.enable = mkForce true;
}
