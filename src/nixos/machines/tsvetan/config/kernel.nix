{ ... }:

# Kernel Management of TSVETAN

{
	boot.kernelParams = [
		"console=ttyS0,115200n8"
		"console=tty0"
		"cma=256M" # 125 to prevent crashes in GNOME, 256 are needed for decoding H.264 videos with CEDRUS
	];
}
