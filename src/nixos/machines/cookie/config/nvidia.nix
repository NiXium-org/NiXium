{ config, lib, ... }:

# Nvidia management of COOKIE

{
	hardware.nvidia = {
		modesetting.enable = true; # Modesetting, which is needed for Wayland compositors

		# TODO(Krey->Tanvir): Known to cause issues, verify on your end-prior to deploying NiXium
		powerManagement.finegrained = true; # Turns off GPU when not in use

		# Outsource this choice on Nixpkgs
		# open = false; # Whether to use the open-source driver

		nvidiaSettings = true; # Enable Nvidia settings menu

		package = config.boot.kernelPackages.nvidiaPackages.production; # Which nvidia package to use
	};

	services.xserver.videoDrivers = [ "nvidia" ]; # Make the xserver to use nvidia
}
