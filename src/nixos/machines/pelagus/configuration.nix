{ pkgs, config, unstable, lib, ... }:

# The Nix Confituration of PELAGUS system

let
	inherit (lib)
		mkIf
		mkForce;
in {
	boot.plymouth.enable = true;

	programs.noisetorch.enable = true;

	services.pcscd.enable = true; # Smart Card Daemon
	services.sunshine.enable = true;
	services.openssh.enable = true;
	services.tor.enable = true;
	# services.i2pd.enable = true;
	services.usbmuxd.enable = true; # iPhone shits
	services.clamav.daemon.enable = true;

	environment.defaultPackages = mkForce []; # Get rid of default packages for minimalism

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	nix.distributedBuilds = true; # Perform distributed builds

	# Enable seemless VM-based cross-compilation
	boot.binfmt.emulatedSystems = [
		"aarch64-linux"
		"riscv64-linux"
		"armv7l-linux"
	];
}
