{ ... }:

{
	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [
		# Auto-Generated
		"xhci_pci"
		# FIXME(Krey): Not Found in Hardened Kernel!
		# "ehci_pc"
		"ahci"
		"usb_storage" # Needed to find the USB device during initrd stage
		"sd_mod"
		"sdhci_pci"
	];
	boot.initrd.kernelModules = [ ];

	boot.initrd.includeDefaultModules = true; # Has to be set to true to be able to input decrypting password

	# FIXME(Krey): We are expecting to use the systemd initrd, but it currently has issues (https://github.com/NixOS/nixpkgs/issues/245089#issuecomment-1646966283)
	boot.initrd.systemd.enable = true;
}
