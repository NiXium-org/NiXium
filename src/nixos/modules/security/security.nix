{ self, lib, ...}:

# Global Security Management

let
	inherit (lib) mkForce;
in {
	system.copySystemConfiguration = mkForce false; # Do not copy system configuration as it will be incomplete and may contain secrets

	boot.loader.systemd-boot.editor = mkForce false; # Do not allow systemd-boot editor as it's set `true` by default for user convicience and can be used to inject root commands to the system
}
