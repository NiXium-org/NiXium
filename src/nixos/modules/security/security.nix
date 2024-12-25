{ self, lib, ...}:

# Global Security Management

let
	inherit (lib) mkForce;
in {
	system.copySystemConfiguration = mkForce false; # Do not copy system configuration as it will be incomplete due to our use of flakes and may contain secrets

	boot.loader.systemd-boot.editor = mkForce false; # Do not allow systemd-boot editor as it's set `true` by default for user convicience and can be used to inject root commands to the system

	# FIXME(Krey): Implement this
	# Remove sudo Lectures
	# security.sudo.extraConfig = ''
  #   # rollback results in sudo lectures after each reboot
  #   Defaults lecture = never
  # '';
}
