{ self, config, lib, ... }:

# Mracek-specific configuration of Open-WebUI

let
	inherit (lib) mkIf;
in mkIf config.services.open-webui.enable {
	# Refer to https://docs.openwebui.com/getting-started/advanced-topics/env-configuration/
	services.open-webui.environment = {
		ENV = "prod"; # Set Production Environment

		CUSTOM_NAME = "NiXium AI";

		# DNM(Krey): This needs to be moved in a secret file and refreshed
		OLLAMA_BASE_URL = "http://somewhereInTheDark.onion";

		# Registrations
		ENABLE_SIGNUP = "False";

		DEFAULT_USER_ROLE = "pending";

		# Disable Spyware
			ENABLE_OPENAI_API = "False";
			ANONYMIZED_TELEMETRY = "False";
			DO_NOT_TRACK = "True";
			SCARF_NO_ANALYTICS = "True";
	};

	# Deploy The Onion Service
		services.tor.relay.onionServices."open-webui".map = mkIf config.services.tor.enable [{
			port = 80;
			target = { port = config.services.open-webui.port; };
		}]; # Set up Onionized WebUI

	# Deploy TTS
		systemd.services.openedai-speech = {
			description = "OpenedAI Speech";
			after = [ "network.target" ];
			wantedBy = [ "multi-user.target" ];

			environment = {
				USE_ROCM = "1";
			};

			serviceConfig = {
				# ExecStartPre = "-${self.inputs.nur-xddxdd.packages.x86_64-linux.openedai-speech}/bin/download_voices_tts-1.sh";
				ExecStart = "${self.inputs.nur-xddxdd.packages.x86_64-linux.openedai-speech}/bin/openedai-speech";
				Restart = "always";
				RestartSec = "3";

				StateDirectory = "openedai-speech";
				WorkingDirectory = "/var/lib/openedai-speech";

				User = "openedai-speech";
				Group = "openedai-speech";
			};
		};

		users.users.openedai-speech = {
			group = "openedai-speech";
			isSystemUser = true;
		};
		users.groups.openedai-speech = { };

		# Set the Voice in OWUI
		services.open-webui.environment = {
			AUDIO_TTS_ENGINE = "openai";
			AUDIO_TTS_API_KEY = "unused";
			AUDIO_TTS_OPENAI_API_BASE_URL = "http://127.0.0.1:8000/v1";
			AUDIO_TTS_OPENAI_API_KEY = "unused";
			AUDIO_TTS_MODEL = "tts-1";
			AUDIO_TTS_VOICE = "alloy";
			AUDIO_TTS_SPLIT_ON = "punctuation";
		};

	# Impermanence
	# environment.persistence."/nix/persist/system".directories = mkIf config.boot.impermanence.enable [
	# 	# FIXME(Krey): This is a temporary solution as the models should be set declaratively
	# 	{ directory = "/var/lib/ollama/models"; user = "ollama"; group = "ollama"; mode = "u=rwx,g=rwx,o="; } # Persist the models
	# ];
}
