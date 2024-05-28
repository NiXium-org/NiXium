{ config, lib, ... }:

# Module exporting configuration from PELAGUS to other systems

let
	inherit (lib) mkIf mkMerge;
in {
		# Add this system into Tor's MapAddress so that we can refer to it easier
		age.secrets.pelagus-onion = {
			file = ./secrets/pelagus-onion.age;

			owner = "tor";
			group = "tor";
			mode = "0400"; # Only read for the user

			# FIXME(Krey): This should be using `config.services.tor.settings.dataDir`, but that results in `error: infinite recursion encountered` so if we ever change the DataDir then that will have to be changed here as well otherwise it will cause issues
			# path = "${config.services.tor.settings.DataDir}/pelagus-onion.conf";
			path = "/var/lib/tor/pelagus-onion.conf";

			# FIXME(Krey): has to be without symlink due to bug with link ownership https://github.com/ryantm/agenix/issues/261
			symlink = false;
		};

		# FIXME-TRANSPARENCY(Krey): This is an encrypted torrc configuration that is parsing `MapAddress pelagus.nx SECRET.onion`, ideally we should handle this through `services.tor.settings.MapAddress` instead which may be possible with scalpel (https://github.com/polygon/scalpel)
		# services.tor.settings."%include" = config.age.secrets."pelagus-onion".path; # Include the MapAddress configuration
}
