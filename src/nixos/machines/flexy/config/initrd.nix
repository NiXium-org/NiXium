{ ... }:

# InitRD Management of FLEXY

{
	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [
		# Auto-Generated
		"nvme"
		"xhci_pci"
		"rtsx_pci_sdmmc"
	];
	boot.initrd.kernelModules = [ ];

	boot.initrd.includeDefaultModules = true; # Has to be set to true to be able to input decrypting password

	# FIXME(Krey): We are expecting to use the systemd initrd, but it currently has issues (https://github.com/NixOS/nixpkgs/issues/245089#issuecomment-1646966283)
	boot.initrd.systemd.enable = false;
}
