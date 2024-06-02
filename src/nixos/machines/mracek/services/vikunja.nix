{ self, config, lib, ... }:

# Mracek-specific configuration of Vikunja

# FIXME(Krey): Add Admin User

let
	inherit (lib) mkIf;
in mkIf config.services.vikunja.enable {
	# Deploy The Onion Service
	services.tor.relay.onionServices."hiddenVikunja".map = mkIf config.services.tor.enable [{
		target = { port = config.services.vikunja.settings.server.HTTP_PORT; };
		port = 80;
	}];
}
