{ config, lib, ... }:

# Hardware-acceleration management of SINNENFREUDE

# dGPU: GTX 760M

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
