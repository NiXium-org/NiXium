{ self, config, lib, ... }:

# Mracek-specific configuration of the Monero Node

let
	inherit (lib) mkIf;
in mkIf config.services.monero.enable {
	# Use pruned blockhain and tor for proxy
	# FIXME-QA(Krey): Use `services.tor.settings.SOCKSPort` for the port?
	services.monero.extraConfig = ''
		prune-blockchain=1
		proxy=127.0.0.1:9050
	'';

	# Deploy The Onion Service
	services.tor.relay.onionServices."hiddenMonero".map = mkIf config.services.tor.enable [ config.services.monero.rpc.port ]; # Set up Onionized Monero Node
}
