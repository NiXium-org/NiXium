{ pkgs, ... }:

# Kernel Management of SINNENFREUDE

{
	boot.kernelPackages = pkgs.linuxPackages_6_8_hardened;

	# Kernel Modules
	boot.kernelModules = [
		"kvm-intel" # Use KVM
	];
}
