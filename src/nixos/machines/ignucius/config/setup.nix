{ config, lib, pkgs, ... }:

# Setup of IGNUCIUS

let
	inherit (lib) mkIf;
in {
	networking.hostName = "ignucius";

	boot.impermanence.enable = true; # Use impermanence

	boot.plymouth.enable = true;

	nix.distributedBuilds = true; # Perform distributed builds

	programs.noisetorch.enable = true;
	programs.adb.enable = true;

	services.openssh.enable = true;
	services.tor.enable = true;
	# TODO(Krey): Pending Management
	services.usbguard.dbus.enable = false;
	services.smartd.enable = true;

	networking.wireguard.enable = false;

	virtualisation.waydroid.enable = true;
	virtualisation.docker.enable = false;

	nix.channel.enable = true; # To be able to use nix repl :l <nixpkgs> as loading flake loads only 16 variables

	users.users.root.openssh.authorizedKeys.keys = mkIf config.services.openssh.enable [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" # Allow root access for the Super Administrator (KREYREN)
	];

	# Desktop Environment
	services.xserver.enable = true;
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.displayManager.gdm.wayland = false; # Do not use wayland as it has issues rn
	services.xserver.desktopManager.gnome.enable = true;
		programs.dconf.enable = true; # Needed for home-manager to not fail deployment (https://github.com/nix-community/home-manager/issues/3113)

	# Fingerprint
	services.fprintd.enable = true;
	services.fprintd.tod.enable = false;

	# Japanese Keyboard Input
	i18n.inputMethod.enabled = "fcitx5";
	i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

	# Power Management
	services.tlp.enable = false;
	services.power-profiles-daemon.enable = true;

	# Extending life of the SSD
	services.fstrim.enable = true;

	age.secrets.ignucius-ssh-ed25519-private.file = ../secrets/ignucius-ssh-ed25519-private.age; # Declare private key

	nixpkgs.hostPlatform = "x86_64-linux";
}
