{ config, lib, pkgs, ... }:

# Global configuration of tor

let
	inherit (lib) mkDefault mkIf;
in mkIf config.services.tor.enable {
	services.tor.relay.role = mkDefault "relay"; # Set relay role as relay by default

	programs.ssh.extraConfig = ''
    Host *.onion
    ProxyCommand ${pkgs.netcat}/bin/nc -X 5 -x 127.0.0.1:9050 %h %p

    Host *.nx
    ProxyCommand ${pkgs.netcat}/bin/nc -X 5 -x 127.0.0.1:9050 %h %p
  '';
}

