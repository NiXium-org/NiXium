{ lib, pkgs, ... }:

# Security enforcement to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	# FIXME(Krey): Figure out if we need this: x86/cpu: SGX disabled by BIOS.

	boot.kernelPackages = mkForce pkgs.linuxPackages_hardened; # Always use Hardened Kernel

	boot.lanzaboote.enable = mkForce true; # Enforce secure boot

	security.allowSimultaneousMultithreading = mkForce false; # Vulnerable af

	security.virtualisation.flushL1DataCache = mkForce null; # Apparently not needed on this system? `null` will let manage it by the kernel

	security.lockKernelModules = mkForce true; # Do not allow unloading of kernel modules

	security.protectKernelImage = mkForce true; # Do not allow to replace the current kernel image

	security.allowUserNamespaces = mkForce true;

	# TBD
	# security.unprivilegedUsernsClone = mkForce false;

	security.tpm2.enable = mkForce true; # Trusted Platform Module 2 support

	# No non-root users expected on the system beyond nix-managed services
	security.sudo.enable = mkForce false;
	security.sudo-rs.enable = mkForce false;
}
