{ pkgs, ... }:

# The Setup of COOKIE system

{
	networking.hostName = "cookie";

	boot.impermanence.enable = true; # Whether To Use Impermanence

	boot.plymouth.enable = true; # Show eyecandy on bootup?

	nix.distributedBuilds = true; # Perform distributed builds

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
	];

	# TODO(Krey->Tanvir): Please check if this is needed
	hardware.enableRedistributableFirmware = true;

	hardware.cpu.intel.updateMicrocode = true; # Use the proprietary CPU microcode as the CPU won't work without it

	nixpkgs.hostPlatform = "x86_64-linux";
}
