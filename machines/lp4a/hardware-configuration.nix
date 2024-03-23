{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of PELAGUS system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	system.stateVersion = "23.11";

	# BootLoader
		boot.loader.systemd-boot.enable = true;
		boot.loader.systemd-boot.editor = mkForce false; # Enforce false as it can be used for code injection to the OS
		boot.loader.efi.canTouchEfiVariables = true; # Unsure if we can touch EFI variables

	services.fwupd.enable = false; # Pointless?

	# Kernel
		# NOTE(Krey): Might need the t-head kernel
		boot.kernelPackages = pkgs.linuxPackages_testing; # Use the testing kernel for now
		# boot.kernelParams = [
		# 	"console=ttyS0,115200n8"
		# ];

		# Kernel Modules
		# boot.kernelModules = [ ]; # TBD
		# boot.extraModulePackages = [ ]; # TBD

	# InitRD Kernel Modules
		# boot.initrd.availableKernelModules = mkForce [
		# 	# Taken from https://github.com/ryan4yin/nixos-licheepi4a/blob/main/modules/licheepi4a.nix#L11
		# 	"ext4"
		# 	"sd_mod"
		# 	"mmc_block"
		# 	"spi_nor"
		# 	"xhci_hcd"
		# 	"usbhid"
		# 	"hid_generic"
		# ];
		# boot.initrd.kernelModules = [ ];

	# Device Tree
		hardware.deviceTree.enable = true; # https://github.com/torvalds/linux/blob/master/arch/riscv/boot/dts/thead/th1520-lichee-pi-4a.dts

	# Filesystem Management
	# fileSystems = {
	# 	"/" = {
	# 		device = "/dev/disk/by-label/ROOT_NIXOS";
	# 		fsType = "btrfs";
	# 	};
	# 	"/boot" = {
	# 		device = "/dev/disk/by-label/BOOT";
	# 		fsType = "vfat"; # FAT32
	# 	};
	# };

	#swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

	# Rendering
		# hardware.opengl.enable = true;

	# Sound
	sound.enable = false; # ALSA
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = false;
		alsa.enable = false;
		alsa.support32Bit = false;
		pulse.enable = false;
		jack.enable = false;

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

	# networking.networkmanager.enable = true;

	nixpkgs.hostPlatform = "riscv64-linux";
	hardware.enableRedistributableFirmware = true; # Is this really needed?
}
