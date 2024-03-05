{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of PELAGUS system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	system.stateVersion = "23.05";

	# SECURITY
	## FIXME(Krey): This should be it's own module applying these things based on presence of the hardware
	security.allowSimultaneousMultithreading = mkForce false; # Ryzen 5 1600 has vulnerable SMT

	# BootLoader
	boot.loader.systemd-boot.enable = mkForce false; # Lanzeboote uses it's own module and requires this disabled
	boot.loader.systemd-boot.editor = false;
	boot.lanzaboote = {
		enable = true; # For Secure-Boot
		pkiBundle = "/etc/secureboot";
	};
	boot.loader.efi.canTouchEfiVariables = true;

	boot.loader.systemd-boot.memtest86.enable = true;

	services.fwupd.enable = true;

	# Kernel
	boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
	boot.kernelParams = [
		# Enable overclocking of AMDGPU
		"amdgpu.ppfeaturemask=0xffffffff"

		# Allegedly disables UMIP (CPU feature) to run hogwards legacy? -- https://github.com/ValveSoftware/Proton/issues/2927
		#"clearcpuid=514"
	];

	# Kernel Modules
	boot.kernelModules = [ "kvm-amd" ];
	boot.extraModulePackages = [ ];

	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
	boot.initrd.kernelModules = [ "amdgpu" ];

	# Filesystem Management
	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/ROOT_NIXOS";
			fsType = "btrfs";
		};
		"/boot" = {
			device = "/dev/disk/by-label/BOOT";
			fsType = "vfat"; # FAT32
		};
	};

	swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

	# Rendering - https://nixos.wiki/wiki/AMD_GPU
	hardware.opengl.driSupport = true;
	hardware.opengl.driSupport32Bit = true;
	hardware.opengl.extraPackages = [
		# The `2023.Q2.1` present in stable channel has issues, so trying unstable
		## FIXME(Krey): If NixOS 23.05 then unstable else driversi686Linux.amdvlk plz
		unstable.amdvlk
		# OpenCL
		pkgs.rocm-opencl-icd
		pkgs.rocm-opencl-runtime
	];
	hardware.opengl.extraPackages32 = [
		# FIXME(Krey): If NixOS 23.05 then unstable else driversi686Linux.amdvlk plz
		unstable.driversi686Linux.amdvlk
	];

	# Steam Hardware
	hardware.steam-hardware.enable = true;

	# Sound
	sound.enable = true; # ALSA
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true; # Broken AF
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;

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

	# Video Drivers
	services.xserver.videoDrivers = [
		(mkIf (config.services.xserver.enable) "amdgpu") # Use AMDGPU if we use xserver
	];

	nixpkgs.hostPlatform = "x86_64-linux";
	hardware.enableRedistributableFirmware = true; # Necessary Evil :(
	hardware.cpu.amd.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
