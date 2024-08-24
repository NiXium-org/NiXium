{ config, lib, ... }:

# Used to outsource nix's build requirements across available systems in the network, on slow devices such as tablets and battery limited devices such as drones this is essential to configure otherwise nix will drain battery and resources from them
#
# Reference: https://nixos.wiki/wiki/Distributed_build

let
	inherit (lib) mkIf;
in mkIf config.nix.distributedBuilds {
	# Authorize TSVETAN
		users.extraUsers.builder.openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3Zr7TFTxa1jKrTl/R5wMDTr9WtmTzgmc7NUnRjUKaD" # TSVETAN
		];

	# Import the SSH Keys for the builder account
	age.secrets.tupac-builder-ssh-ed25519-private = {
		file = ../secrets/tupac-builder-ssh-ed25519-private.age;

		owner = "builder";
		group = "builder";
		mode = "660"; # rw-rw----

		path = (if config.boot.impermanence.enable
			then "/nix/persist/system/etc/ssh/ssh_builder_ed25519_key"
			else "/etc/ssh/ssh_builder_ed25519_key");

		symlink = false; # Appears to not work as symlink
	};

	# Set the pubkey
	environment.etc."ssh/ssh_builder_ed25519_key.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBSPCMXZ6377AeL5ZKdv7Y041CIJ2lhKl/YH/tbY7xc builder@tupac";

	# Impermanence
	environment.persistence."/nix/persist/system".files = mkIf config.boot.impermanence.enable [
		"/etc/ssh/ssh_builder_ed25519_key" # Builder account for distributed builds
	];
}
