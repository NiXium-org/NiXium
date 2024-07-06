{ config, lib, ... }:

# Module that is going to set up the TANVIR user

let
	inherit (lib) mkIf mkForce;
in {
	age.secrets.tanvir-user-password.file = ./tanvir-user-password.age;
	# sops.secrets."users/tanvir/hashed-password".neededForUsers = true;

	users.users.tanvir = {
		description = "Osprey"; # FIXME(Krey): Figure out how to handle this
		isNormalUser = true;
		createHome = true;
		hashedPasswordFile = config.age.secrets.tanvir-user-password.path;
		# hashedPasswordFile = config.sops.secrets."users/tanvir/hashed-password".path;
		extraGroups = [
			(mkIf config.virtualisation.docker.enable "docker")
			"dialout" # To Access e.g. /dev/ttyUSB0 for USB debuggers
		];
		# TODO(Krey->Tanvir): Add your keys here
		openssh.authorizedKeys.keys = [ "ssh-ed25519 ADD_ME" ];
	};

	# Set up the user directory
	# FIXME(Krey): Causes an infinite recursion, no idea why
	# disko.devices.nodev."/home/kreyren" = mkIf config.boot.impermanence.enable {
	# disko.devices.nodev."/home/kreyren" = {
	# 	fsType = "tmpfs";
	# 	mountOptions = [
	# 		"size=1G"
	# 		"defaults"
	# 		"mode=755"
	# 	];
	# };

	users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ]; # Allow root access for all systems for kreyren

	nix.settings.trusted-users = [ "kreyren" ]; # Add Kreyren in Trusted-Users
}
