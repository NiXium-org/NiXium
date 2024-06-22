{ ... }:

# Bootloader management of TUPAC

{
	# TODO(Krey): Tupac supports secure-boot which needs to be deployed manually on the system
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot
	boot.loader.systemd-boot.enable = true; # Whether to use the systemd for boot

	boot.loader.efi.canTouchEfiVariables = true; # Whether the EFI variables are writable
}
