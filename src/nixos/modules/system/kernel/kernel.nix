{ lib, pkgs, ... }:

# Global Kernel Module

let
	inherit (lib) mkForce mkDefault;
in {
	boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened; # Always prefer the Hardened Kernel

	security.lockKernelModules = mkDefault true; # Lock Kernel Modules by default

	security.protectKernelImage = mkDefault true; # Protect Kernel Image by default
}
