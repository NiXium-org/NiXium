{ config, lib, unstable, pkgs, ... }:

# Hardware-specific configuration of ASUS system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	system.stateVersion = "23.11";

	# FIXME(Krey): Can reportedly be used to enter the passphrase
	# boot.initrd.network.ssh.enable = true;
	# boot.initrd.network.enable = true;

	# BootLoader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# FIXME(Krey): It doesn't do the blacklisting for some reason..
	boot.blacklistedKernelModules = [
		"backlight" # Eats constantly ~1W of power even with lid closed and display turned off
		"realtek" # Eats ~0.40 W
		"asus-nb-wmi" # Eats ~0.30 W
		"spi_intel" #  ~0.30 W
	];

	# boot.loader.systemd-boot.memtest86.enable = true;

	## Kernel ##
		# boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
		boot.kernelPackages = pkgs.linuxPackages_hardened;
		# boot.kernelPackages = pkgs.linuxPackages_6_6_hardened; # Hoyfix for inability to input decrypting password
		# boot.kernelPackages = pkgs.linuxPackages;
		boot.kernelParams = [
			# https://docs.kernel.org/admin-guide/hw-vuln/tsx_async_abort.html
			"tsx=auto"
			"tsx_async_abort=full,nosmt"
			"mds=off" # Just in case..
		];

		# Kernel Modules
		boot.kernelModules = [ "kvm-intel" ];
		boot.extraModulePackages = [ ];

		# InitRD Kernel Modules
		boot.initrd.availableKernelModules = [
			# Auto-Generated
			"xhci_pci"
			"ahci"
			"usb_storage" # Needed to find the USB device during initrd stage
			"sd_mod"
			"rtsx_usb_sdmmc"
		];
		boot.initrd.kernelModules = [ ];

		boot.initrd.includeDefaultModules = true; # Has to be set to true to be able to input decrypting password

		boot.initrd.systemd.enable = true;

	services.acpid.enable = true; # Maybe fix ACPI errors?

	# Nvidia - GTX 1050M
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
	};

	## Nvidia, Fuck you! .. and your proprietary piece of shit code ##
		# # Configure nVidia including Optimus
		# services.xserver.videoDrivers = ["nvidia"];

		# hardware.nvidia = {
		# 	## Enable modesetting - Needed for Wayland compositors
		# 	modesetting.enable = true;

		# 	open = false; # Do not use open-source drivers, because it complains that GPU System Processor ("GSP") is not supported in the open nvidia.ko

		# 	nvidiaSettings = false; # Disable nVidia settings menu, because no GUI

		# 	powerManagement = {
		# 		enable = true;
		# 		# finegrained = true;
		# 	};

		# 	## Optionally you may need to select the appropriate driver version for your specific GPU
		# 	package = config.boot.kernelPackages.nvidiaPackages.stable;

		# 	prime = {
		# 		# sync.enable = true; # Server configuration
		# 		offload.enable = true;
		# 		offload.enableOffloadCmd = true;
		# 		intelBusId = "PCI:00:02:0"; # 00:02.0
		# 		nvidiaBusId = "PCI:01:00:0"; # 01:00.0
		# 	};
		# };

	## Sound ##
		## Is not used and only takes out power -> Disable
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

	## Printing ##
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

	## Networking ##
		networking.useDHCP = mkDefault true; # Use DHCP on all adapters
		# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

		networking.networkmanager.enable = true;

	## Power Management ##
		services.thermald.enable = true;
		services.auto-cpufreq.enable = true;
		# https://github.com/AdnanHodzic/auto-cpufreq/blob/v1.9.9/auto-cpufreq.conf-example
		services.auto-cpufreq.settings = {
			charger = {
				governor = "powersave";

				scaling_min_freq = 800000; # 800 MHz = 800000 kHz --> scaling_min_freq = 800000

				scaling_max_freq = 1000000; # 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000

				turbo = "auto";
			};

			battery = {
				governor = "powersave";

				scaling_min_freq = 800000; # 800 MHz = 800000 kHz --> scaling_min_freq = 800000

				scaling_max_freq = 1000000; # 1GHz = 1000 MHz = 1000000 kHz -> scaling_max_freq = 1000000

				turbo = "auto";
			};
		};
		services.logind.lidSwitch = "lock"; # Do not suspend on loss of power

		# powerManagement = {
		# 	# driver: intel_pstate
		# 	cpuFreqGovernor = "powersave"; # Don't be so aggressive with the CPU scheduling
		# 	# cpufreq = {
		# 	# 	min = 800000; # Minimal CPU frequency e.g.   800000 = 800 kHz
		# 	# 	max = 1000000; # Maximal CPU frequency e.g. 2200000 = 2.2 GHz
		# 	# };
		# 	# scsiLinkPolicy = "min_power"; # SCSI link power management policy
		# };

	nixpkgs.hostPlatform = "x86_64-linux";
	hardware.enableRedistributableFirmware = true; # Necessary Evil :(
	hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

	services.fwupd.enable = false; # hotfix
}
