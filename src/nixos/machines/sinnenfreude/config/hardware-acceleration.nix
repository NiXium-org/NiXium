{ config, lib, ... }:

# Hardware-acceleration management of SINNENFREUDE

# dGPU: GTX 760M

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

# FIXME-QA(Krey): This was my original idea and it looks so functional and beautiful! U_U But Nix will fail at inifite recursion err with this and it seems that the only way to fix that is using mkIf
# let
# 	inherit (lib) mkIf;
# in mkIf (true) {
# 	"24.05" = {
# 		hardware.opengl = {
# 			enable = true;
# 			driSupport = true;
# 			driSupport32Bit = true;
# 		};
# 	};

# 	_ = {
# 		hardware.opengl = {
# 			enable = true;
# 			driSupport32Bit = true;
# 		};
# 	};
# }."${config.system.nixos.release}"
