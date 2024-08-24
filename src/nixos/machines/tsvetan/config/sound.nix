{ ... }:

# Sound management of TSVETAN

{
	sound.enable = true; # ALSA

	# Disable Pulseaudio as pipewire manages that within it's declaration
	hardware.pulseaudio.enable = false;

	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# To use real-time scheduling priority for audio
	security.rtkit.enable = true;
}
