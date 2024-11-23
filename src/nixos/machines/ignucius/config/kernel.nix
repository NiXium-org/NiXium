{ pkgs, lib, ... }:

# Kernel Management of IGNUCIUS

let
	inherit (lib) mkForce;
in {
	boot.kernelPackages = mkForce pkgs.linuxPackages;

	# The driver causes conflicts with ACPI driver, so it's disabled (https://forums.gentoo.org/viewtopic-t-1068292-start-0.html)
	boot.blacklistedKernelModules = [ "lpc_ich" ];

	boot.kernelModules = [
		"kvm-intel" # Use KVM
		"usb-storage" # Use USB drives on hardened kernel
	];
}
