{
	users.users.veloraptor = {
		description = "Veloraptor";
		isNormalUser = true;
		# TODO(Kira): Set up OpenSSH keys and add agenix declaration
		extraGroups = [
			"wheel"
			"docker"
			"dialout" # To Access e.g. /dev/ttyUSB0 for USB debuggers
		];
		# openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ];
	};
}
