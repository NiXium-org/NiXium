{ config, ... }:

# Hardware-acceleration management of SINNENFREUDE

# dGPU: GTX 760M


{
	"24.05" = {
		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};
	};

	_ = {
		hardware.opengl = {
			enable = true;
			driSupport32Bit = true;
		};
	};
}." ${config.system.nixos.release}"
