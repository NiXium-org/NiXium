{ self, lib, ...}:

# Global Security Management

let
	inherit (lib) mkForce;
in {
	system.copySystemConfiguration = mkForce false; # Do not copy system configuration as it will be incomplete and may contain secrets
}
