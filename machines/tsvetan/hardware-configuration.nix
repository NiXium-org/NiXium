{ config, lib, unstable, pkgs, crossPkgs,... }:

# Hardware-specific configuration of TSVETAN system

let
	inherit (lib)
		mkIf
		mkDefault
		mkForce;
in {
	system.stateVersion = "23.05";

	# Boot Management
		hardware.deviceTree.enable = true;
		boot.loader.systemd-boot.enable = true;
		boot.loader.systemd-boot.editor = false;
		boot.loader.efi.canTouchEfiVariables = false; # TowBoot doesn't do that according to samueldr (the creator)

	# Plymouth
		boot.plymouth.enable = true;

	# Kernel
		# https://discourse.nixos.org/t/the-correct-way-to-override-the-latest-kernel-config/533/5
		# Set according to https://nixos.wiki/wiki/Linux_kernel#Custom_configuration to test hypothesis in https://github.com/NixOS/nixpkgs/issues/260222#issuecomment-1869774655
		# boot.kernelPackages = pkgs.linuxPackages;
		boot.kernelPackages = pkgs.linuxPackages_hardened;
		# boot.kernelPackages = crossPkgs.linuxPackages;
		# boot.kernelPackages = crossPkgs.linuxPackages_latest;
		# boot.kernelPatches = [ {
		# 	name = "teres_i-config";
		# 	# patch = ./thing.patch;
		# 	patch = null;
		# 	extraConfig = ''
		# 		CMA_SIZE_MBYTES 128
		# 		THERMAL n
		# 	'';
		# } ];

		# Use defaults
		boot.kernelParams = [
			"console=ttyS0,115200n8"
			"console=tty0"
			"cma=128M" # Prevent crashes
		];

		# Kernel Modules
		boot.kernelModules = [];
		boot.extraModulePackages = [];

	# InitRD
		boot.initrd.systemd.enable = true;

		boot.initrd.availableKernelModules = [
			"usbhid"
			"snd_seq_dummy"
			"snd_hrtimer"
			"snd_seq"
			"qrtr"
			"snd_seq_device"
			"crct10dif_ce"
			"polyval_ce"
			"polyval_generic"
			"sm4"
			"axp20x_battery"
			"axp20x_ac_power"
			"axp20x_adc"
			"axp20x_pek"
			"pinctrl_axp209"
			"analogix_anx6345"
			"analogix_dp"
			"r8723bs"
			"snd_soc_simple_card"
			"drm_display_helper"
			"snd_soc_simple_card_utils"
			"lima"
			"sun8i_rotate"
			"gpu_sched"
			"sun8i_di"
			"sun50i_codec_analog"
			"cfg80211"
			"drm_shmem_helper"
			"sun8i_adda_pr_regmap"
			"uvcvideo"
			"v4l2_mem2mem"
			"sun8i_a33_mbus"
			"sunxi_wdt"
			"videobuf2_dma_contig"
			"sun8i_codec"
			"sun4i_i2s"
			# "uvc" # Not found?
			"videobuf2_vmalloc"
			"pwm_sun4i"
			"videobuf2_memops"
			"rfkill"
			"videobuf2_v4l2"
			"libarc4"
			"videodev"
			"onboard_usb_hub"
			"sun8i_ce"
			"videobuf2_common"
			"mc"
			"sun4i_drm"
			"sun8i_mixer"
			"sun4i_tcon"
			"sun8i_tcon_top"
			"drm_dma_helper"
			"sun6i_dma"
			"drm_kms_helper"
			"snd_soc_simple_amplifier"
			"pwm_bl"
			"nls_iso8859_1"
			"nls_cp437"
			"mousedev"
			"xt_conntrack"
			"uio_pdrv_genirq"
			"nf_conntrack"
			"nf_defrag_ipv6"
			"uio"
			"nf_defrag_ipv4"
			"ip6t_rpfilter"
			"ipt_rpfilter"
			"xt_pkttype"
			"xt_LOG"
			"nf_log_syslog"
			"xt_tcpudp"
			"nft_compat"
			"nf_tables"
			"sch_fq_codel"
			"tap"
			"macvlan"
			"bridge"
			"stp"
			"llc"
			"drm"
			"fuse"
			"backlight"
			"nfnetlink"
			"dmi_sysfs"
			"ip_tables"
			"x_tables"
			"dm_crypt"
			"encrypted_keys"
			"trusted"
			"caam_jr"
			"libdes"
			"authenc"
			"caamhash_desc"
			"caamalg_desc"
			"caam"
			"error"
			"crypto_engine"
			"asn1_encoder"
			"dm_mod"
			"dax"
			"btrfs"
			"blake2b_generic"
			"libcrc32c"
			"xor"
			"xor_neon"
			"raid6_pq"
		];
		# boot.initrd.availableKernelModules = [ "usbhid" ];
		# boot.initrd.availableKernelModules = [
		# 	"usbhid"
		# 	"lima"
		# 	"analogix_anx6345"
		# 	"drm"
		# 	"analogix_dp"
		# 	"sun4i_drm"
		# 	"sun4i_tcon"
		# 	"gpu_sched"
		# 	"sun8i_mixer"
		# 	"drm_kms_helper"
		# 	"drm_dma_helper"
		# 	"drm_shmem_helper"
		# 	"drm_display_helper"
		# ];
		boot.initrd.kernelModules = [];

		# FIXME-UPSTREAM(Krey): This is not enough to get working display in initrd
		# boot.initrd.includeDefaultModules = true;

	# Filesystem Management
		boot.initrd.luks.devices."rootfs".device = "/dev/disk/by-uuid/d76dcad7-e22c-4442-910e-cf147911bd57";

		fileSystems = {
			"/" = {
				device = "/dev/disk/by-uuid/3868a3b9-c46f-42d4-8428-274b5e86c86a";
				fsType = "btrfs";
			};
			"/boot" = {
				device = "/dev/disk/by-uuid/7C02-0A33";
				fsType = "vfat"; # FAT32
			};
		};

		swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

	# Steam Hardware
		hardware.steam-hardware.enable = false;

	# Sound
		# sound.enable = true; # Only meant for ALSA-based systems? (https://nixos.wiki/wiki/PipeWire)
		hardware.pulseaudio = {
			enable = mkIf config.services.pipewire.enable false; # PipeWire expects this set to false
			package = pkgs.pulseaudioFull;
		};
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			audio.enable = true; # Use PipeWire as the primary sound server
			alsa.enable = true;
			alsa.support32Bit = false; # TBD
			pulse.enable = true;
			jack.enable = true;
		};

	# Printing
		### NOTE(Krey): Doesn't print, likely fasistic printer
		services.printing.enable = false;
		#services.printing.drivers = [ unstable.canon-cups-ufr2 ];
		# hardware.printers.ensureDefaultPrinter = "MF4400-Series-FAX";
		# hardware.printers = {
		# 	ensurePrinters = [
		# 		{
		# 			name = "MF4400-Series-FAX";
		# 			#location = "Home";
		# 			deviceUri = "usb://Canon/MF4400%20Series%20FAX?serial=1112D5202094&interface=2";
		# 			model = "CNRCUPSMF4400ZJ.ppd";
		# 			# ppdOptions = {
		# 			# 	PageSize = "A4";
		# 			# };
		# 		}
		# 	];
		# };

	# Networking
		networking.useDHCP = mkDefault true; # Use DHCP on all adapters
		# networking.interfaces.eno1.useDHCP = lib.mkDefault true;

		networking.networkmanager.enable = true;

	# Misc
		hardware.enableRedistributableFirmware = true;

	# Hardware Acceleration
		hardware.opengl = {
			enable = true;
			driSupport = true;
			# driSupport32Bit = true; # "Option driSupport32Bit only makes sense on a 64-bit system." ?
		};

	# Platform
		nixpkgs.hostPlatform = "aarch64-linux";
}
