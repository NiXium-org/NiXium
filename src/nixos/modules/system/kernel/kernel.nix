{ lib, pkgs, ... }:

# Global Kernel Module

let
	inherit (lib) mkForce mkDefault;
in {
	boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened; # Always prefer the Hardened Kernel

	security.lockKernelModules = mkForce true; # Do not allow loading and unloading of kernel modules

	security.protectKernelImage = mkForce true; # Do not allow to replace the current kernel image
}
