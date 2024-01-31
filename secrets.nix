# Standalone ragenix secret declaration

# FIXME-SECURITY(Krey): The declarations of systems enables attack vector of physically taking the device and then reading the /etc/ssh/ssh_host_*_key to be able to decrypt the agenix files and/or read their content in /run/agenix.d which needs to be managed.. e.g. the user password doesn't have to stay there after it's been set? Point being avoiding attacker access to the whole infra if one system is compromised

let
	kreyren = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve";

	pelagus-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhxI+25BwlCuEezW6Vc4mJ+EP/KO597PI2YfEU9t+vf";
	sinnenfreude-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7nLConnVyxn/ZTQXIReXo6x3CbAMky6YVmZ7iMIP5Q";
	tsvetan-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOdXo/F5GFtiiy7ItHr7+aCpM9BE18N0ecfZleS2qhrO";
	asus-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN/iuA5q4bZnG1WW8i+gyWoPYvmtxXRoDyKSzleJyfVn";
in {
	"./nixos/users/kreyren/kreyren-user-password.age".publicKeys = [
		kreyren pelagus-host sinnenfreude-host tsvetan-host asus-host
	];
}
