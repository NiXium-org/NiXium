{ config, lib, ... }:

# Used to outsource nix's build requirements across available systems in the network, on slow devices such as tablets and battery limited devices such as drones this is essential to configure otherwise nix will drain battery and resources from them
#
# Reference: https://nixos.wiki/wiki/Distributed_build

let
	inherit (lib) mkIf;
in {
	# Authorize tsvetan
	users.extraUsers.builder.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF18QG9oqeeq/lQc5QDJl3hz5D4Q9bhiHFTRLJN4KSZb" # TSVETAN
	];
}
