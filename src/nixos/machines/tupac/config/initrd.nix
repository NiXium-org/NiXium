{ ... }:

{
	boot.initrd.systemd.enable = true; # Use Systemd for initrd

	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [
		# Auto-Generated
		"xhci_pci"
		"nvme"
		"usb_storage"
		"sd_mod"
		"sdhci_pci"
	];
	boot.initrd.kernelModules = [ ];

	# FIXME-OPTIMIZE(Krey): This can be heavily optimized, but it's very time consuming to maintain
	boot.initrd.includeDefaultModules = true; # Include default modules for amd64 systems to endure functionality during initrd
}
