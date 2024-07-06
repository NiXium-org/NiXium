{ ... }:

# Bootloader management of COOKIE

{
	# TODO(Krey->Tanvir): Secure boot on x86_64 systems has to be set up in an impure way, refer to lanzaboote files and submit a merge request with changes
	boot.loader.systemd-boot.enable = true;
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot

	boot.loader.efi.canTouchEfiVariables = true; # Whether the EFI variables are writable
}
