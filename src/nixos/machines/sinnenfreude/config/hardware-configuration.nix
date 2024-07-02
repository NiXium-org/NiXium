{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of SINNENFREUDE system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	networking.hostName = "sinnenfreude";

	# BootLoader
	## NOTE(Krey): Has a weird BIOS, lanzaboote has issues with deployment
	boot.loader.systemd-boot.enable = true; # Lanzeboote uses it's own module and requires this disabled
	boot.loader.systemd-boot.editor = false;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.loader.systemd-boot.memtest86.enable = true;

	# Kernel
	# boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
	boot.kernelPackages = pkgs.linuxPackages_6_8_hardened;

	# Kernel Modules
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [ ];

	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	# Nvidia
	## NOTE(Krey): Legacy GPU supported by driver 470.xx (https://www.nvidia.com/en-us/drivers/unix/legacy-gpu)
	# Configure nVidia including Optimus
	# services.xserver.videoDrivers = ["nvidia"];
	# hardware.nvidia = {
	# 	modesetting.enable = true; # Enable modesetting - Needed for Wayland compositors

	# 	# GTX760M is not supported: This version of NVIDIA driver does not provide a corresponding opensource kernel driver
	# 	open = false; # Whether to use the open-source driver

	# 	# Enable Nvidia settings menu
	# 	nvidiaSettings = true;

	# 	## Optionally you may need to select the appropriate driver version for your specific GPU
	# 	package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

	# 	prime = {
	# 		sync.enable = false; # Sync Mode
	# 		offload.enable = true; # OffLoading Mode
	# 		offload.enableOffloadCmd = true; # Provide `nvidia-run` executable to enforce use of dGPU
	# 		intelBusId = "PCI:00:02:0"; # 00:02.0
	# 		nvidiaBusId = "PCI:01:00:0"; # 01:00.0
	# 	};
	# };

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

	## Printing
	### NOTE(Krey): Doesn't print, likely fasistic printer
	services.printing.enable = false;
	#services.printing.drivers = [ unstable.canon-cups-ufr2 ];
	# # SECURITY(Krey): Should be hidden
	# hardware.printers.ensureDefaultPrinter = "MF4400-Series-FAX";
	# hardware.printers = {
	# 	ensurePrinters = [
	# 		{
	# 			# SECURITY(Krey): Should be hidden
	# 			name = "MF4400-Series-FAX";
	# 			#location = "Home";
	# 			deviceUri = "usb://Canon/MF4400%20Series%20FAX?serial=1112D5202094&interface=2";
	# 			model = "CNRCUPSMF4400ZJ.ppd";
	# 			# ppdOptions = {
	# 			# 	PageSize = "A4";
	# 			# };
	# 		}
	# 	];
	# };

	# Networking
	networking.useDHCP = mkDefault true; # Use DHCP on all adapters
	# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

	networking.networkmanager.enable = true;

	nixpkgs.hostPlatform = "x86_64-linux";
	hardware.enableRedistributableFirmware = true; # Necessary Evil :(
	hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
