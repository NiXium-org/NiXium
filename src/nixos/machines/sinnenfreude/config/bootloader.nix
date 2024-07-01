{ ... }:

# Bootloader management of SINNENFREUDE

{
	# Has weird BIOS that doesn't work reliably with secure boot
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot
	boot.loader.systemd-boot.enable = true;

	boot.loader.efi.canTouchEfiVariables = true;
}
