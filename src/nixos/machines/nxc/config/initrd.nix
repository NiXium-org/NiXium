{ config, lib, ... }:

# InitRD Management of NXC

let
	inherit (lib) mkIf;
in {
	# InitRD Kernel Modules
	boot.initrd.availableKernelModules = [
		# Auto-Generated
		"ahci"
		"sr_mod"
		"xhci_pci"

		# QEMU-Guest Recommendations
		"virtio_net"
		"virtio_pci"
		"virtio_mmio"
		"virtio_blk"
		"virtio_scsi"
		"9p"
		"9pnet_virtio"
	];

	boot.initrd.kernelModules = [
		"virtio_balloon"
		"virtio_console"
		"virtio_rng"
		"virtio_gpu"
	];

	boot.initrd.systemd.enable = true;

  boot.initrd.postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable)
    ''
      # Set the system time from the hardware clock to work around a
      # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
      # to the *boot time* of the host).
      hwclock -s
    '';
}
