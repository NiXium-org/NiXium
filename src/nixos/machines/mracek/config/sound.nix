{ ... }:

# Sound management of MRACEK

# NOTE(Krey): Sound is expected to never be used and only takes out power -> Disable everything

{
	sound.enable = false;

	hardware.pulseaudio.enable = false;

	services.pipewire = {
		enable = false;
		alsa.enable = false;
		alsa.support32Bit = false;
		pulse.enable = false;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	security.rtkit.enable = false;
}
