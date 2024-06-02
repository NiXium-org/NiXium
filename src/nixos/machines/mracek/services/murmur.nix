{ self, config, lib, ... }:

# Mracek-specific configuration of MurMur

let
	inherit (lib) mkIf;
in mkIf config.services.murmur.enable {
	# Deploy The Onion Service
	services.tor.relay.onionServices."hiddenMurmur".map = mkIf config.services.tor.enable [ config.services.murmur.port ]; # Set up Onionized Murmur
}
