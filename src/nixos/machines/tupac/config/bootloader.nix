{ ... }:

# Bootloader management of TUPAC

{
	boot.lanzaboote.enable = true; # Whether to use NixOS's implementation of secure-boot

	boot.loader.efi.canTouchEfiVariables = true; # Whether the EFI variables are writable
}
