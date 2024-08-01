{ ... }:

# Bootloader management of NXC

{
	# TODO(Krey): To be managed
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot
	boot.loader.systemd-boot.enable = true;

	security.tpm2.enable = true;

	boot.loader.efi.canTouchEfiVariables = true;
}
