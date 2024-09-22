{ pkgs, config, lib, ... }:

# Kernel Management of MORPH

let
	inherit (lib) mkIf;
in {
	boot.kernelPackages = pkgs.linuxPackages_hardened;

	# Kernel Modules
	boot.kernelModules = [
		"kvm-intel" # Use KVM
		(mkIf config.networking.wireguard.enable "wireguard")
	];

	boot.extraModulePackages = [ ];
}
