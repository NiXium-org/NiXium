{ config, lib, ... }:

# Global configuration of monero

let
	inherit (lib) mkIf mkForce mkDefault;
in mkIf config.services.openssh.enable {
	services.openssh.settings.PasswordAuthentication = mkForce false; # Password Authentification prohibited, depends on pubkeys

	services.openssh.openFirewall = mkDefault false; # Do not automatically open the firewall
}

