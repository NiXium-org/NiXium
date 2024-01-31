{ config, lib, ... }:

# Global configuration of tor

let
	inherit (lib) mkDefault mkIf;
in mkIf config.services.tor.enable {
	services.tor.relay.role = mkDefault "relay"; # Set relay role as relay by default
}

