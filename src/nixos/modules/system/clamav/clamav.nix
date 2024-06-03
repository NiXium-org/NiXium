{ lib, config, pkgs, ... }:

# ClamAV configuration

let
	inherit (lib) mkIf;
in mkIf config.services.clamav.daemon.enable {
	environment.systemPackages = [ pkgs.clamtk ]; # Install clamtk system-wide if clamav is used

	services.clamav.updater.enable = true; # Daemon to update malware definitions
}
