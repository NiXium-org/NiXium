{ lib, config, ... }:

# Set up CCache if it's enabled as instructed in https://nixos.wiki/wiki/CCache#NixOS

let
	inherit (lib) mkIf;
in mkIf config.system.autoUpgrade.enable {
	system.autoUpgrade.dates = "*:0/10"; # Attempt an autoUpgrade every 10 min
}
