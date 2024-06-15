{ ... }:

{
	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [
		# Auto-Generated
		"xhci_pci"
		"ahci"
		"usb_storage" # Needed to find the USB device during initrd stage
		"sd_mod"
		"rtsx_usb_sdmmc"
	];
	boot.initrd.kernelModules = [ ];

	boot.initrd.includeDefaultModules = true; # Has to be set to true to be able to input decrypting password

	boot.initrd.systemd.enable = true;
}