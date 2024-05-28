{ config, ... }:

{
	# FIXME-QA(Krey): This is supposed to be in it's invidual `./machine/SYSTEM/export.nix` directories, but i dunno how to fix `error: The option `services.tor.settings."%include"' has conflicting definition values:`
	services.tor.settings."%include" = [
		config.age.secrets."pelagus-onion".path

		config.age.secrets."mracek-onion".path
		config.age.secrets."mracek-vikunja-onion".path
		config.age.secrets."mracek-gitea-onion".path
		config.age.secrets."mracek-monero-onion".path
		config.age.secrets."mracek-murmur-onion".path
		config.age.secrets."mracek-navidrome-onion".path

		config.age.secrets."sinnenfreude-onion".path
	];
}
