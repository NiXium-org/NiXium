{ pkgs,... }:

# The Setup of SINNENFREUDE system

{
	boot.impermanence.enable = true; # Use impermanence

	boot.plymouth.enable = true;

	nix.distributedBuilds = true; # Perform distributed builds

	programs.noisetorch.enable = true;

	services.flatpak.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;
	programs.dconf.enable = true; # Needed for home-manager to not fail deployment (https://github.com/nix-community/home-manager/issues/3113)

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];
}
