{ lib, pkgs, ... }:

# Security enforcement of CPU to manage issues on the MRACEK system

let
	inherit (lib) mkForce;
in {
	security.allowSimultaneousMultithreading = mkForce false; # Vulnerable af

	security.virtualisation.flushL1DataCache = mkForce null; # Apparently not needed on this system? `null` will let manage it by the kernel
}
