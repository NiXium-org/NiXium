{ lib, config, ... }:

# Security management of COOKIE

let
	inherit (lib) mkMerge;
in {
	# NOTE(Krey): Breaks hibernation
	security.protectKernelImage = true;

	security.lockKernelModules = true;

	# NOTE(Krey): Currently not used as Tor is too slow making Nix daemon too inefficient to work reliably
	# config = mkMerge [
	# 	# Enforce to use the Tor Proxy
	# 	# NOTE(Krey): It's currently causing issues
	# 	# (mkIf config.services.tor.enable {
	# 	# 	networking.proxy.default = mkDefault "socks5://127.0.0.1:9050";
	# 	# 	networking.proxy.noProxy = mkDefault "127.0.0.1,localhost";
	# 	# })
	# ];
}
