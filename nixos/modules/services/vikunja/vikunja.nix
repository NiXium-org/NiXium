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
}
