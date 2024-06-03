{ config, lib, ... }:

# Pelagus-specific management of sunshine service

let
	inherit (lib) mkIf;
in mkIf config.services.sunshine.enable {
	services.sunshine.capSysAdmin = true; # Set CapSysAdmin

	# FIXME-QA(Krey): Set temporarely for testing, expected to be managed with tailscale or alike
	services.sunshine.openFirewall = true; # Open Firewall
}
