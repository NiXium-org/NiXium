{ config, ... }:

# Sound management of COOKIE

# NOTE(Krey): `hardware.pulseaudio.enable` seems to need to be set to false for services.pipewire.pulse.enable to allow true for pulse integration in pipewire

{
	sound.enable = true; # Whether to use ALSA
	hardware.pulseaudio.enable = false; # Whether to use pulseaudio
	services.pipewire.enable = true; # Whether to use pipewire

	# Pipewire
	# FIXME-QA(Krey): This should be reviewed whether we want to move it into a global configuration
	services.pipewire = {
		alsa.enable = config.sound.enable; # Integrate alse in pipewire
		alsa.support32Bit = config.sound.enable; # Allow 32-bit ALSA support
		pulse.enable = true; # Integrate pulseaudio in pipewire
	};

	security.rtkit.enable = true; # Allow real-time scheduling priority to user
}
