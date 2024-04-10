{ self, config, lib, ... }:

# Mracek-specific configuration of Gitea

let
	inherit (lib) mkIf;
in mkIf config.services.gitea.enable {
	services.gitea.appName = "KREYREN's Gitea Service";

	# NOTE(Krey): Pending management of secrets for onion addreses for MapAddress
	# services.gitea.settings.server.ROOT_URL = "http://gitea.nixium"; # Set the ROOT URL needed for UI to know how to show up things

	# FIXME(Krey): This is enterprise-edition-only feature which should be available in the open-source edition -> Propose this to upstream
	services.gitea.settings.security.ENFORCE_TWO_FACTOR_AUTH = true; # Require 2FA to access repositories (https://docs.gitea.com/enterprise/features/mandatory-2fa)

	services.gitea.settings.service.DISABLE_REGISTRATION = true; # Disable registration as gitea is easy target for bots and we are planing on managing the users differently

	services.gitea.settings.server.DISABLE_SSH = true; # NOTE(Krey): Disable SSH as i have yet to figure out how to manage this
}
