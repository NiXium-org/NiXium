{ lib, config, ... }:

# Set up CCache if it's enabled as instructed in https://nixos.wiki/wiki/CCache#NixOS

let
	inherit (lib) mkIf;
in mkIf config.programs.ccache.enable {
	nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
}
