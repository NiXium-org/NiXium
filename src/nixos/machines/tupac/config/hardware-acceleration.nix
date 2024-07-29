{ config, lib, ... }:

# Hardware-acceleration management of TUPAC

let
	inherit (lib) mkMerge mkIf;
in {
	# FIXME-QA(Krey): I hate this solution, this would work much better as case statement, but that causes infinite recursion..
	config = mkMerge [
		(mkIf (config.system.nixos.release == "24.05") {
			hardware.opengl = {
				enable = true;
				driSupport = true;
				driSupport32Bit = true;
			};
		})

		(mkIf (config.system.nixos.release == "24.11") {
			hardware.graphics.enable = true;
			hardware.graphics.enable32Bit = true;
		})
	];
}
