{ lib, config, pkgs, ... }:

# ClamAV configuration

let
	inherit (lib) mkIf;
in mkIf config.services.clamav.daemon.enable {
	environment.systemPackages = [ pkgs.clamtk ]; # Install clamtk system-wide if clamav is used so that it's available to the users

	services.clamav.updater.enable = true; # Daemon to update malware definitions

	# Impermanence
	environment.persistence."/nix/persist/system".directories = mkIf config.boot.impermanence.enable [
		(mkIf config.services.clamav.daemon.enable config.services.clamav.updater.settings.DatabaseDirectory) # ClamAV
	];
}
