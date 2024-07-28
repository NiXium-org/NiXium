{ ... }:

# Bootloader management of SINNENFREUDE

{
	# Refer to https://github.com/NixOS/nixpkgs/pull/324911#discussion_r1690615341 for details to why we don't use lanzaboote here
	boot.lanzaboote.enable = false; # Whether to use NixOS's implementation of secure-boot
	boot.loader.systemd-boot.enable = true;

	security.tpm2.enable = true;

	boot.loader.efi.canTouchEfiVariables = true;
}
