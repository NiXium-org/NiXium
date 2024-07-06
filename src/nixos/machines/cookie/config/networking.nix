{ lib, ... }:

# Networking management of TUPAC

let
	inherit (lib) mkForce;
in {
	networking.networkmanager.enable = mkForce true; # Always use NetworkManager over the default

	# TODO(Krey->Tanvir): Propose changes to what you want to add here from https://github.com/TanvirOnGH/nixos-config/blob/afc413f90ebaaf0030a15bfa819b4a873c5d889b/hardware/network/internet.nix#L4, note that DNS managment is pending in https://github.com/NiXium-org/NiXium/issues/36 with projected end-goal being using lokinet's DNS

	#Available: enp42s0 (ethernet) and wlp41s0 (wifi)
	networking.interfaces.enp42s0.useDHCP = true;
}
