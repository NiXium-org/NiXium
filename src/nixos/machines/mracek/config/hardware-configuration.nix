{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of ASUS system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	networking.hostName = "mracek";

	services.logind.lidSwitchExternalPower = "lock"; # Lock the system on closing the lid when on external power instead of suspend/hibernation

	# BootLoader
		boot.loader.systemd-boot.enable = true;
		# NOTE(Krey): Set to false as it seems to break diskoScriptImage for some reason
		boot.loader.efi.canTouchEfiVariables = false;
		# boot.loader.systemd-boot.memtest86.enable = true;

	# Kernel
		boot.kernelModules = [
			"kvm-intel" # Load KVM
		];

	# Nvidia - GTX 1050M
		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};

	# Sound
		# NOTE(Krey): Is expected to never be used and only takes out power -> Disable everything
		sound.enable = false;
		hardware.pulseaudio.enable = false;
		security.rtkit.enable = false;
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

	# Networking
		# FIXME-QA(Krey): Enable DHCP only on specified adapters
		networking.useDHCP = mkDefault true; # Use DHCP on all adapters
		# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

		networking.networkmanager.enable = true;

	nixpkgs.hostPlatform = "x86_64-linux";
}
