{ pkgs, config, lib, ... }:

# Kernel Management of SINNENFREUDE

let
	inherit (lib) mkIf;
in {
	boot.kernelPackages = pkgs.linuxPackages_hardened;

	# SECURITY(Krey): Some packages run in electron (session-desktop, vscodium) which requires this, in process of getting rid of them
	security.unprivilegedUsernsClone = true;

	# Kernel Modules
	boot.kernelModules = [
		"kvm-intel" # Use KVM
		(mkIf config.networking.wireguard.enable "wireguard")
	];
}
