{ armTrustedFirmwareAllwinner
, buildUBoot
}:

{
	ubootOlimexA64Teres1 = buildUBoot {
		defconfig = "teres_i_defconfig";
		extraMeta.platforms = ["aarch64-linux"];
		BL31 = "${armTrustedFirmwareAllwinner}/bl31.bin";
		# Using /dev/null here is upstream-specified way that disables the inclusion of crust-firmware as it's not yet packaged and without which the build will fail -- https://docs.u-boot.org/en/latest/board/allwinner/sunxi.html#building-the-crust-management-processor-firmware
		SCP = "/dev/null";
		filesToInstall = ["u-boot-sunxi-with-spl.bin"];
	};
}
