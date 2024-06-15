{ self, lib, ... }:

# Global Firewall Management

let
	inherit (lib) mkDefault;
in {
	networking.firewall.enable = mkDefault true; # Always use firewall by default
}
