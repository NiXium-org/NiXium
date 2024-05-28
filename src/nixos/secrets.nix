# Standalone ragenix secret declaration

let
	# Users
	kreyren = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve";
	# kira = "ssh-ed25519 ...";

	# Systems
	mracek-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHN94Qu1y0r2WAgfhixLo5shNOVDUqctFGVJ14wOxnE/";
	pelagus-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhxI+25BwlCuEezW6Vc4mJ+EP/KO597PI2YfEU9t+vf";
	sinnenfreude-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7nLConnVyxn/ZTQXIReXo6x3CbAMky6YVmZ7iMIP5Q";
	tsvetan-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5uH+tcDY1/1oWFwMzFwtgiI9v0riml0T//k9h+v7kj";
	tupac-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmYpmNkpSkSSk1FnxHvPb8JlbeYh2lf3d5u8MBqGpHP";

	all-systems = [
		mracek-system
		pelagus-system
		sinnenfreude-system
		tsvetan-system
		tupac-system
	];
in {
	# Kreyren (user)
	"./users/kreyren/kreyren-user-password.age".publicKeys = [
		kreyren
	] ++ all-systems;

	# MRACEK (system)
	"./machines/mracek/secrets/disks-password.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-vikunja-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-gitea-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-monero-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-murmur-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-navidrome-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	# PELAGUS (system)
	"./machines/pelagus/secrets/disks-password.age".publicKeys = [
		kreyren pelagus-system
	];
	"./machines/pelagus/secrets/pelagus-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	# SINNENFREUDE (system)
	"./machines/sinnenfreude/disks-password.age".publicKeys = [
		kreyren sinnenfreude-system
	];
	"./machines/sinnenfreude/secrets/sinnenfreude-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	# TSVETAN (system)
	"./machines/tsvetan/disks-password.age".publicKeys = [
		kreyren tsvetan-system
	];

	# TUPAC (system)
	"./machines/tupac/disks-password.age".publicKeys = [
		kreyren tsvetan-system
	];
}
