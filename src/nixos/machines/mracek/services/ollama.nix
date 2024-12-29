{ self, config, lib, ... }:

# Mracek-specific configuration Ollama

let
	inherit (lib) mkIf mkForce;
in mkIf config.services.ollama.enable {
	services.open-webui.enable = true; # Enable the WebUI Frontend for Ollama
		# services.open-webui.port = 8080; # Set Port for the WebUI

	# Deploy The Onion Service
	services.tor.relay.onionServices."open-webui".map = mkIf config.services.tor.enable [{ port = 80; target = { port = config.services.open-webui.port; }; }]; # Set up Onionized WebUI
	services.tor.relay.onionServices."ollama".map = mkIf config.services.tor.enable [{ port = 11434; target = { port = config.services.ollama.port; }; }]; # Set up Onionized WebUI

	services.ollama.acceleration = "cuda";
	services.ollama.openFirewall = true;

	# FIXME(Krey): Set the system into sync mode until we figure out how to use offloading correctly here
	hardware.nvidia.prime.sync.enable = mkForce true;
	hardware.nvidia.prime.offload.enable = mkForce false;
	hardware.nvidia.prime.offload.enableOffloadCmd = mkForce false;
	hardware.nvidia.powerManagement.finegrained = mkForce false; # Turns off GPU when not in use

	# Deploy TTS
		systemd.services.openedai-speech = {
			description = "OpenedAI Speech";
			after = [ "network.target" ];
			wantedBy = [ "multi-user.target" ];

			serviceConfig = {
				ExecStartPre = "-${self.inputs.nur-xddxdd.packagesWithCuda.x86_64-linux.openedai-speech}/bin/download_voices_tts-1.sh";
				ExecStart = "${self.inputs.nur-xddxdd.packagesWithCuda.x86_64-linux.openedai-speech}/bin/openedai-speech --host 127.0.0.1 --port 12884";
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
			AUDIO_TTS_OPENAI_API_BASE_URL = "http://127.0.0.1:12884";
			AUDIO_TTS_OPENAI_API_KEY = "unused";
			AUDIO_TTS_MODEL = "tts-1";
			# AUDIO_TTS_VOICE = "zh-CN-XiaoxiaoNeural";
			AUDIO_TTS_SPLIT_ON = "punctuation";
		};

	# Impermanence
	environment.persistence."/nix/persist/system".directories = mkIf config.boot.impermanence.enable [
		# FIXME(Krey): This is a temporary solution as the models should be set declaratively
		{ directory = "/var/lib/ollama/models"; user = "ollama"; group = "ollama"; mode = "u=rwx,g=rwx,o="; } # Persist the models
	];
}
