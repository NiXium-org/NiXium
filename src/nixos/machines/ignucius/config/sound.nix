{ config, lib, ... }:

# Sound management of IGNUCIUS

let
	inherit (lib) mkMerge mkIf;
in {
	config = mkMerge [
		(mkIf (config.system.nixos.release == "24.05") {
			sound.enable = true;

			hardware.pulseaudio.enable = false;

			services.pipewire = {
				enable = true;
				alsa.enable = true;
				alsa.support32Bit = true;
				pulse.enable = true;
			};
		})

		(mkIf (config.system.nixos.release == "24.11") {
			hardware.pulseaudio.enable = false;

			services.pipewire = {
				enable = true;
				alsa.enable = true;
				alsa.support32Bit = true;
				pulse.enable = true;
			};
		})

		{
			security.rtkit.enable = true; # To Get Real-Time priority for Audio
		}
	];
}