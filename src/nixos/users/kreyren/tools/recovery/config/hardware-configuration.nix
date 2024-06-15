{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of SINNENFREUDE system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	networking.hostName = "recovery";

	system.stateVersion = "24.05";

	# BootLoader
	boot.loader.systemd-boot.editor = true;

	# False appears to work on a systems tha have touchable variables and also on those who doesn't
	boot.loader.efi.canTouchEfiVariables = false;

	boot.loader.systemd-boot.memtest86.enable = true;

	# Kernel
	boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;

	# Kernel Modules
	# FIXME(Krey): Figure out how to manage this for aarch64, riscv64 and armv7l
	boot.kernelModules = [ "kvm-intel" "kvm-amd" ]; # Load KVM for both intel and AMD for compatibility
	boot.extraModulePackages = [ ];

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	# Steam Hardware
	hardware.steam-hardware.enable = true;

	# Sound
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# Printing
		services.printing.enable = false;

	# Networking
		networking.useDHCP = mkDefault true; # Use DHCP on all adapters

		networking.networkmanager.enable = true;

	nixpkgs.hostPlatform = "x86_64-linux";
	hardware.enableRedistributableFirmware = true; # Necessary Evil :(
	hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
