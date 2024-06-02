{ lib, pkgs, ... }:

# Kernel-related Security enforcement to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	boot.kernelPackages = mkForce pkgs.linuxPackages_hardened; # Always use Hardened Kernel

	security.lockKernelModules = mkForce true; # Do not allow loading and unloading of kernel modules

	security.protectKernelImage = mkForce true; # Do not allow to replace the current kernel image
}
