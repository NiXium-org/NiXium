{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of TUPAC system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	networking.hostName = "tupac";

	system.stateVersion = "24.05";

	# Hardware acceleration
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	# Steam Hardware
	hardware.steam-hardware.enable = true;

	# Networking
	networking.useDHCP = mkDefault true; # Use DHCP on all adapters
	# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

	networking.networkmanager.enable = true;

	# Necessary Evil :(
	hardware.enableRedistributableFirmware = true;
	hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

	nixpkgs.hostPlatform = "x86_64-linux";
}
