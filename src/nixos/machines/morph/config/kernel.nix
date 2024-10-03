{ pkgs, config, lib, ... }:

# Kernel Management of MORPH

let
	inherit (lib) mkIf;
in {
	# NOTE(Krey): Morph is projected to be used as a gaming server where the hardened kernel might impact it's performance too much
	boot.kernelPackages = pkgs.linuxPackages_hardened;

	# Kernel Modules
	boot.kernelModules = [
		"kvm-intel" # Use KVM
		(mkIf config.networking.wireguard.enable "wireguard")
	];

	boot.extraModulePackages = [ ];
}
