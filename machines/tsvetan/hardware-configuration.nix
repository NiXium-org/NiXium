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
		boot.loader.systemd-boot.enable = true;
		boot.loader.systemd-boot.editor = false;
		boot.loader.efi.canTouchEfiVariables = false; # TowBoot doesn't do that according to samueldr (the creator)

	# Plymouth
		boot.plymouth.enable = true;

	# Kernel
		# https://discourse.nixos.org/t/the-correct-way-to-override-the-latest-kernel-config/533/5
		# Set according to https://nixos.wiki/wiki/Linux_kernel#Custom_configuration to test hypothesis in https://github.com/NixOS/nixpkgs/issues/260222#issuecomment-1869774655
		# boot.kernelPackages = pkgs.linuxPackages;
		boot.kernelPackages = pkgs.linuxPackages_hardened;
		# boot.kernelPackages = crossPkgs.linuxPackages;
    # boot.kernelPackages = crossPkgs.linuxPackages_testing;
    # boot.kernelPatches = [
			# {
			# 	name = "teres_i-config";
			# 	patch = ./thing.patch;
			# 	# extraConfig = ''
			# 	# 	CMA_SIZE_MBYTES 128
			# 	# 	THERMAL n
			# 	# '';
			# }
      # {
      # 	name = "work-patch";
      # 	patch = ./work.patch;
      # }
      # {
      # 	name = "anx6345-hotfix";
      # 	patch = ./anx6345-hotfix.patch;
      # }
    # ];

		# Use defaults
		boot.kernelParams = [
			"console=ttyS0,115200n8"
			"console=tty0"
			"cma=128M" # Prevent crashes
		];

		# Kernel Modules
		boot.kernelModules = [];
		boot.extraModulePackages = [];

	# InitRD
		boot.initrd.systemd.enable = true;
		boot.initrd.availableKernelModules = [
			"usbhid" # for USB

			# For display
			"sun4i-drm"
			"sun4i-tcon"
			"sun8i-mixer"
			"sun8i_tcon_top"
			"gpu-sched"
			"drm"
			"drm_shmem_helper"
			"drm_kms_helper"
			"drm_dma_helper"
			"drm_display_helper"
			"analogix_anx6345"
			"analogix_dp"
		];
		boot.initrd.kernelModules = [];

		# FIXME-UPSTREAM(Krey): This is not enough to get working display in initrd, discuss including the modules above by default
		# boot.initrd.includeDefaultModules = true;

	# Filesystem Management
		boot.initrd.luks.devices."rootfs".device = "/dev/disk/by-uuid/d76dcad7-e22c-4442-910e-cf147911bd57";

		fileSystems = {
			"/" = {
				device = "/dev/disk/by-uuid/3868a3b9-c46f-42d4-8428-274b5e86c86a";
				fsType = "btrfs";
			};
			"/boot" = {
				device = "/dev/disk/by-uuid/7C02-0A33";
				fsType = "vfat"; # FAT32
			};
		};

		swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

	# Steam Hardware
		hardware.steam-hardware.enable = false;

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

	# Misc
		hardware.enableRedistributableFirmware = true;

	# Hardware Acceleration
		hardware.opengl = {
			enable = true;
			driSupport = true;
			# driSupport32Bit = true; # "Option driSupport32Bit only makes sense on a 64-bit system." ?
		};

	# Platform
		nixpkgs.hostPlatform = "aarch64-linux";
}
