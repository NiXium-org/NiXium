{ lib, pkgs, ... }:

# Security enforcement to manage issues on the PELAGUS system

# PELAGUS is non-hardened system used as an offloading server for gaming, compilation and processing alike

let
	inherit (lib) mkForce;
in {

	boot.lanzaboote.enable = mkForce true; # Enforce secure boot

	# NOTE-SECURITY(Krey): The SMT is vulnerable which is the main reason to why this server is designated as an non-hardened offloading
	security.allowSimultaneousMultithreading = mkForce true;

	security.virtualisation.flushL1DataCache = mkForce "never"; # All users on this system are trusted

	security.lockKernelModules = mkForce true; # Do not allow loading and unloading of kernel modules

	security.protectKernelImage = mkForce true; # Do not allow to replace the current kernel image

	security.allowUserNamespaces = mkForce true;

	# TBD
	# security.unprivilegedUsernsClone = mkForce false;

	security.tpm2.enable = mkForce true; # Trusted Platform Module 2 support

	# No non-root users expected on the system beyond nix-managed services
	security.sudo.enable = mkForce false;
	security.sudo-rs.enable = mkForce false;

	networking.firewall.enable = mkForce true; # Enforce the Firewall

	# Enforce to use the Tor Proxy
	# FIXME-QA(Krey): Only apply if tor is enabled
	networking.proxy.default = mkForce "socks5://127.0.0.1:9050";
	networking.proxy.noProxy = mkForce "127.0.0.1,localhost";
}
