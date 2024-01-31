{ lib, config, ... }:

# Global default configuration and management of vikunja service

# FIXME-PRIVACY(Krey): Make vikunja use tor proxy for accessing internet

let
	inherit (lib) mkDefault mkIf;
in mkIf config.services.vikunja.enable {
	# Mandatory configuration to get vikunja to work
	services.vikunja.frontendScheme = mkDefault "http";
	services.vikunja.frontendHostname = mkDefault "localhost";

	# FIXME(Krey): Figure out how to run this without nginx
	services.nginx.enable = true;
	services.vikunja.setupNginx = true;

	environment.persistence."/nix/persist/service/vikunja" = {
		hideMounts = true;
		directories = [
			"/var/lib/tor/onion/hiddenVikunja" # Tor Files
			"/var/lib/private/vikunja"
		];
		# files = [
		# 	# NOTE/FIXME(Krey): Do not use `config.services.vikunja.database.path` here bcs it saves a symlink in /var/lib/vikunja/vikunja.db that points to /var/lib/private/vikunja/vikunja.db
		# 	# "/var/lib/private/vikunja/vikunja.db" # Database
		# 	# "/etc/vikunja/config.yaml"
		# ];
	};
}
