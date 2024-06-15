{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of TSVETAN system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	networking.hostName = "tsvetan";

	system.stateVersion = "24.05";

	# Boot Management
		hardware.deviceTree.enable = true;
		boot.loader.systemd-boot.enable = true;
		boot.loader.systemd-boot.editor = false;
		boot.loader.efi.canTouchEfiVariables = false; # TowBoot doesn't do that according to samueldr (the creator)

	# Kernel
		boot.kernelPackages = pkgs.linuxPackages;

		boot.kernelParams = [
			"console=ttyS0,115200n8"
			"console=tty0"
			"cma=256M" # 125 to prevent crashes in GNOME, 256 are needed for decoding H.264 videos with CEDRUS
		];

	# Hardware
		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};

		# Steam Hardware
		hardware.steam-hardware.enable = true;

	# Sound
		sound.enable = true; # Only meant for ALSA-based systems? (https://nixos.wiki/wiki/PipeWire)
		hardware.pulseaudio = {
			enable = mkIf config.services.pipewire.enable false; # PipeWire expects this set to false
			package = pkgs.pulseaudioFull;
		};
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			audio.enable = true; # Use PipeWire as the primary sound server
			alsa.enable = true;
			alsa.support32Bit = false; # TBD
			pulse.enable = true;
			jack.enable = true;
		};

	# Printing
		services.printing.enable = false;

	# Networking
		networking.useDHCP = mkDefault true; # Use DHCP on all adapters

		networking.networkmanager.enable = true;

	# Misc
		hardware.enableRedistributableFirmware = true; # Needed for the WiFi until the linux-libre hack is implemented or better staging drivers

	# Platform
		nixpkgs.hostPlatform = "aarch64-linux";
}
