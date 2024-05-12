{ config, pkgs, lib, ... }:

let
	inherit (lib) mkIf mkForce;
in {
	users.users.kira = {
		description = "Veloraptor";
		isNormalUser = true;
		# TODO(Kira): Set up OpenSSH keys and add agenix declaration
		extraGroups = [
			"wheel"
			(mkIf config.virtualisation.docker.enable "docker")
			"dialout" # To Access e.g. /dev/ttyUSB0 for USB debuggers
		];
		# openssh.authorizedKeys.keys = [ "ssh-ed25519 xxxx name@domain.tld" ];
	};
}
