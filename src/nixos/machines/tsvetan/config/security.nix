{ lib, config, pkgs, ... }:

# Security management of TSVETAN

let
	inherit (lib) mkMerge mkForce mkDefault mkIf;
in mkMerge [
	# Enforce to use the Tor Proxy
	# (mkIf config.services.tor.enable {
	# 	networking.proxy.default = mkDefault "socks5://127.0.0.1:9050";
	# 	networking.proxy.noProxy = mkDefault "127.0.0.1,localhost";
	# })
]
