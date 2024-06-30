{ ... }:

# The Setup of TUPAC system

{
	networking.hostName = "tupac";

	# WARNING(Krey): Non-impermanent setup was not tested, but expected to work
	boot.impermanence.enable = true; # Whether To Use Impermanence

	boot.plymouth.enable = false; # Show eyecandy on bootup?

	nix.distributedBuilds = true; # Perform distributed builds

	programs.steam.enable = true;
	programs.noisetorch.enable = true; # Microphone filtering

	services.flatpak.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;
	programs.dconf.enable = true; # Needed for home-manager to not fail deployment (https://github.com/nix-community/home-manager/issues/3113)

	# Japanese Keyboard Input
	# i18n.inputMethod.enabled = "fcitx5";
	# i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Which locales to support
	i18n.supportedLocales = [
		"en_US.UTF-8/UTF-8"
		"cs_CZ.UTF-8/UTF-8"
	];

	hardware.steam-hardware.enable = true; # Compatibility for Steam Controller

	hardware.enableRedistributableFirmware = true; 	# There should be nothing on this system that needs proprietary firmware, but the user likely uses proprietary peripherals

	hardware.cpu.intel.updateMicrocode = true; # Use the proprietary CPU microcode as the CPU won't work without it

	# FIXME(Krey): This should be managed elsewhere
	nixpkgs.hostPlatform = "x86_64-linux";
}
