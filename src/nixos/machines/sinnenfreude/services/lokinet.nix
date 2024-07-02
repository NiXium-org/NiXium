{ config, ... }:

# Lokinet Management of SINNENFREUDE

{
	networking.nameservers = [ config.services.lokinet.settings.dns.bind ]; # Use the Lokinet-provided DNS server to resolve .loki addresses

	# WARNING(Krey): This Needs To Be Made Impermanent otherwise reboot will refresh the key
	services.lokinet.settings.network.keyfile = "snappkey.private"; # Set the keyfile so that the loki URL remains the same after service restart

	# FIXME(Krey): We need to set a URL alias for
	# services.lokinet.settings.network.mapaddr = "somewhereInTheDark.loki:sinnenfreude.systems.nxl";
}
