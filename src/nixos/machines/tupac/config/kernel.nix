{ pkgs, ... }:

# Kernel management of TUPAC

{
	boot.kernelPackages = pkgs.linuxPackages_xanmod_stable; # Use the stable Xanmod Kernel

	# Kernel Modules
	boot.kernelModules = [ "kvm-intel" ];
	boot.extraModulePackages = [ ];
}
