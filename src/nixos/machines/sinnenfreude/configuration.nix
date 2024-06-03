{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of SINNENFREUDE system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	nix.distributedBuilds = true; # Perform distributed builds

	programs.noisetorch.enable = true;

	services.flatpak.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Enable seemless VM-based cross-compilation
	boot.binfmt.emulatedSystems = [
		"aarch64-linux"
		"riscv64-linux"
		"armv7l-linux"
	];
}
