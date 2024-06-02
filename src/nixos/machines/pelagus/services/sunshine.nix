{ config, lib, ... }:

# Pelagus-specific management of sunshine service

let
	inherit (lib) mkIf;
in mkIf config.services.sunshine.enable {
	services.sunshine.capSysAdmin = true; #
	services.sunshine.openFirewall = true;
}
