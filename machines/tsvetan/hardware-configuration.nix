{ config, lib, unstable, pkgs, crossPkgs,... }:

# Hardware-specific configuration of TSVETAN system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	system.stateVersion = "23.05";

	# Boot Management
	hardware.deviceTree.enable = true;
	boot.loader.grub.enable = false; # NixOS enables grub by default.. annoying
	boot.loader.generic-extlinux-compatible.enable = true; # Enables the generation of `/boot/extlinux/extlinux.conf`

	# Plymouth
	## FIXME(Krey): Plymouth doesn't show for some reason
	boot.plymouth.enable = false;

	# https://discourse.nixos.org/t/the-correct-way-to-override-the-latest-kernel-config/533/5
	# Set according to https://nixos.wiki/wiki/Linux_kernel#Custom_configuration to test hypothesis in https://github.com/NixOS/nixpkgs/issues/260222#issuecomment-1869774655
	boot.kernelPackages = crossPkgs.linuxPackages;
	boot.kernelPatches = [ {
		name = "teres_i-config";
		patch = null;
		extraConfig = ''
			CMA_SIZE_MBYTES 128
		'';
	} ];
	boot.kernelParams = [];

	# Kernel Modules
	boot.kernelModules = [];
	boot.extraModulePackages = [ ];

	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = ["usbhid"];
	boot.initrd.kernelModules = [];

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

	# Steam Hardware
	#hardware.steam-hardware.enable = true;

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
	# hardware.printers.ensureDefaultPrinter = "MF4400-Series-FAX";
	# hardware.printers = {
	# 	ensurePrinters = [
	# 		{
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

	# Platform
	nixpkgs.hostPlatform = "aarch64-linux";
}
