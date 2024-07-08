{ pkgs, config, lib, ... }:

# Kernel Management of SINNENFREUDE

let
	inherit (lib) mkIf;
in {
	#boot.kernelPackages = pkgs.linuxPackages_6_9_hardened;
	boot.kernelPackages = pkgs.linuxPackages;

	# SECURITY(Krey): Some packages run in electron which requires this, in process of getting rid of them
	#security.unprivilegedUsernsClone = true;

	# Kernel Modules
	boot.kernelModules = [
		"kvm-intel" # Use KVM
		(mkIf config.networking.wireguard.enable "wireguard")
	];
}
