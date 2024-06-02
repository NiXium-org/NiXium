{ lib, pkgs, ... }:

# Security enforcement of network to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	networking.firewall.enable = mkForce true; # Enforce the Firewall

	# Enforce to use the Tor Proxy
	networking.proxy.default = mkForce "socks5://127.0.0.1:9050";
	networking.proxy.noProxy = mkForce "127.0.0.1,localhost";
}
