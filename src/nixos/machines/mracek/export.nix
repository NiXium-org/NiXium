{ config, lib, ... }:

# Module exporting configuration from MRACEK to other systems

let
	inherit (lib) mkIf mkMerge;
in {
	# SSHD on Onions
		# Add this system into Tor's MapAddress so that we can refer to it easier
		age.secrets.mracek-onion = {
			file = ./secrets/mracek-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

	# Vikunja service
		age.secrets.mracek-vikunja-onion = {
			file = ./secrets/mracek-vikunja-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-vikunja-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

	# Gitea service
		age.secrets.mracek-gitea-onion = {
			file = ./secrets/mracek-gitea-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-gitea-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

	# Monero Node service
		age.secrets.mracek-monero-onion = {
			file = ./secrets/mracek-monero-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-monero-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

	# Murmur Node service
		age.secrets.mracek-murmur-onion = {
			file = ./secrets/mracek-murmur-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-murmur-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

	# Navidrome service
		age.secrets.mracek-navidrome-onion = {
			file = ./secrets/mracek-navidrome-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/mracek-navidrome-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};
}
