{ config, lib, pkgs, ... }:

# Morph-specific configuration Ollama

let
	inherit (lib) mkForce mkIf;
in mkIf config.services.ollama.enable {
	services.ollama.acceleration = "rocm";

	# Deploy on Onions
		services.tor.relay.onionServices."ollama".map = mkIf config.services.tor.enable [{ port = 11434; target = { port = config.services.ollama.port; }; }]; # Set up Onionized WebUI

		# This is needed to allow connections from Tor that relays dark into 0.0.0.0
		services.ollama.host = "0.0.0.0";

		services.ollama.environmentVariables = {
			HSA_OVERRIDE_GFX_VERSION = "10.3.0";
			ROC_ENABLE_PRE_VEGA = "1";
		};

	# Impermanence
	environment.persistence."/nix/persist/system".directories = mkIf config.boot.impermanence.enable [
		# FIXME(Krey): This is a temporary solution as the models should be set declaratively
		{ directory = "/var/lib/ollama/models"; user = "ollama"; group = "ollama"; mode = "u=rwx,g=rwx,o="; } # Persist the models
	];
}
