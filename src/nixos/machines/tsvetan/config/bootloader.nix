{ ... }:

# Bootloader management of TSVETAN

{
	# NOTE(Krey): Lanzaboote doesn't support aarch64
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot
	boot.loader.systemd-boot.enable = true;

	# Doesn't seem to have Touchable EFI Variables
	boot.loader.efi.canTouchEfiVariables = false;
}
