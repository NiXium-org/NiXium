{ config, lib, ... }:

# Global configuration of monero

let
	inherit (lib) mkDefault mkIf;
in mkIf config.services.monero.enable {
	services.monero.extraConfig = "prune_blockchain=1"; # Use pruned node
}

