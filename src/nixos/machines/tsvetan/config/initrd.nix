{ ... }:

# InitRD Management of TSVETAN

{
	boot.initrd.systemd.enable = true;

	boot.initrd.availableKernelModules = [
		"usbhid" # for USB

		# For display
		"sun4i-drm"
		"sun4i-tcon"
		"sun8i-mixer"
		"sun8i_tcon_top"
		"gpu-sched"
		"drm"
		"drm_shmem_helper"
		"drm_kms_helper"
		"drm_dma_helper"
		"drm_display_helper"
		"analogix_anx6345"
		"analogix_dp"
	];
	
	boot.initrd.kernelModules = [ ];
}