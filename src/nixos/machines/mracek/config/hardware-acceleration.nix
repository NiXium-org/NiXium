{ lib, config, ... }:

# Hardware-acceleration management of MRACEK

# dGPU: GTX 1050M

let
	inherit (lib) mkMerge mkIf;
in {
	config = mkMerge [
		(mkIf (config.system.nixos.release == "24.05") {
			hardware.opengl = {
				enable = true;
				driSupport = true;
				driSupport32Bit = true;
			};
		})

		# Everything else
		(mkIf (config.system.nixos.release != "24.05") {
			hardware.opengl = {
				enable = true;
				driSupport32Bit = true;
			};
		})
	];
}
