{ config, lib, pkgs, ... }:

let
	inherit (lib) mkForce mkDefault;
in {
	system.stateVersion = "23.11";

	# Bootloader
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

	# Kernel
		# boot.kernelPackages = pkgs.linuxPackages;
		boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
		boot.kernelParams = [];
		boot.kernelModules = [ "kvm-intel" ];
		boot.extraModulePackages = [ ];

	# InitRD
		boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
		boot.initrd.kernelModules = [ ];

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

	# Nvidia (https://nixos.wiki/wiki/Nvidia)
		hardware.opengl = {
			enable = true; # Enable 3D-accelaration
			driSupport = true;
			driSupport32Bit = true;
		};

		# Load nvidia driver for Xorg and Wayland
		services.xserver.videoDrivers = [ "nvidia" ];

		hardware.nvidia = {
			modesetting.enable = true; # Required

			# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
			powerManagement.enable = false;

			# Fine-grained power management. Turns off GPU when not in use. Experimental and only works on modern Nvidia GPUs (Turing or newer).
			powerManagement.finegrained = true; # This is RTX4060

			# Use the NVidia open source kernel module (not to be confused with the
			# independent third-party "nouveau" open source driver).
			# Support is limited to the Turing and later architectures. Full list of
			# supported GPUs is at:
			# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
			# Only available from driver 515.43.04+
			# Currently alpha-quality/buggy, so false is currently the recommended setting.
			open = mkForce false; # Appears to have issues on the open atm

			# Enable the Nvidia settings menu, accessible via `nvidia-settings`.
			nvidiaSettings = true;

			# Offloading on dGPU
			prime = {
				offload = {
					enable = true; # Use offloading
					enableOffloadCmd = true; # provide 'nvidia-offload' command
				};
				intelBusId = "PCI:1:0:0"; # Intel GPU bus
				nvidiaBusId = "PCI:0:2:0"; # Nvidia GPU bus
			};

			package = config.boot.kernelPackages.nvidiaPackages.production; # Specify the Nvidia Driver package
		};

	# FWUPD
		services.fwupd.enable = true; # Service used to manage the onboard firmware

	# Hardware
		hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
}
