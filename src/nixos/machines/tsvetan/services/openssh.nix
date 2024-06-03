{ self, config, lib, ... }:

# TSVETAN-specific configuration of OpenSSH

let
	inherit (lib) mkIf;
in mkIf config.services.openssh.enable {
	services.tor.relay.onionServices."hiddenSSH".map = mkIf config.services.tor.enable config.services.openssh.ports; # Provide hidden SSH
}
