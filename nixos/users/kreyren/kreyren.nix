{ config, lib, ... }:

let
	inherit (lib) mkIf mkForce;
	username = "raptor";
	# old-username = "raptor";
in {
	users.users."${username}" = {
		description = "Raptor"; # FIXME(Krey): Figure out how to handle this
		isNormalUser = true;
		#hashedPasswordFile = mkForce config.age.secrets.kreyren-user-password.path;
		extraGroups = [
			"wheel"
			(mkIf config.virtualisation.docker.enable "docker")
			"dialout" # To Access e.g. /dev/ttyUSB0 for USB debuggers
		];
		openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ];
	};

	age.secrets.kreyren-user-password.file = ./kreyren-user-password.age;

	# Allow root access
	users.users.root.openssh.authorizedKeys.keys = mkForce config.users.users."${username}".openssh.authorizedKeys.keys;

	# Impermenance
	## FIXME(Krey): Figure out how we want to handle this
	# environment.persistance.users."${username}" = {
	# 	directories = {
	# 		...
	# 	};
	# 	files = [
	# 		...
	# 	];
	# };
}
