{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of TUPAC system

{
	networking.hostName = "tupac";

	system.stateVersion = "24.05";

	# There should be nothing on this system that needs proprietary firmware, but the user likely uses proprietary peripherals
	hardware.enableRedistributableFirmware = true;

	hardware.cpu.intel.updateMicrocode = true; # Use the proprietary CPU microcode as the CPU won't work without it

	nixpkgs.hostPlatform = "x86_64-linux";
}
