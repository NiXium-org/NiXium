{ ... }:

# Sound management of NXC

# NOTE(Krey): Sound is expected to never be used and only takes out power -> Disable everything

{
	sound.enable = false;

	hardware.pulseaudio.enable = false;

	services.pipewire = {
		enable = false;
		alsa.enable = false;
		alsa.support32Bit = false;
		pulse.enable = false;
	};

	security.rtkit.enable = false;
}
