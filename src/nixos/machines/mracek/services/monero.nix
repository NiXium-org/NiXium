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

	# Import the private key for an onion service
	age.secrets.mracek-onion-monero-private = {
		file = ../secrets/mracek-onion-monero-private.age;

		owner = "tor";
		group = "tor";

		path = "/var/lib/tor/onion/monero/hs_ed25519_secret_key";

		symlink = false; # Appears to not work as symlink
	};

	# Deploy The Onion Service
	services.tor.relay.onionServices."monero" = {
		map = mkIf config.services.tor.enable [{ port = config.services.monero.rpc.port; target = { port = 18081; }; }]; # Set up Onionized Monero Node
	};
}
