# Standalone ragenix secret declaration

# TODO(Krey): Pending Rework

let
	# Users
	kreyren = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve";
	kira = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWLIYYAXRUD0+bg5CXsxh9F4spvqCz4jaxvtGMsezl/";

	# Systems
	flexy-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQei8wZXD379qw4ygSTOZ1cdj6vHwtFG7QsuWdT0UlM";
	mracek-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP8d9Nz64gE+x/+Dar4zknmXMAZXUAxhF1IgrA9DO4Ma";
	pelagus-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhxI+25BwlCuEezW6Vc4mJ+EP/KO597PI2YfEU9t+vf";
	sinnenfreude-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIAXnS4xUPWwjBdKDvvy5OInLbs3oeHUUs5qUsX+fBji";
	tsvetan-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdqMVQ3TO5ckmk9nepAY/7zLHy555EkzBJxpfTIwuT5";
	tupac-system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmYpmNkpSkSSk1FnxHvPb8JlbeYh2lf3d5u8MBqGpHP";

	all-systems = [
		flexy-system
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

	"./users/kreyren/home/modules/vpn/kreyren-wireproxy-protonvpn-config.age".publicKeys = [
		kreyren sinnenfreude-system
	];

	# Kira (user)
	"./users/kira/kira-user-password.age".publicKeys = [
		kreyren kira
	] ++ all-systems;

	"./users/kira/home/modules/vpn/kira-wireproxy-protonvpn-config.age".publicKeys = [
		kira kreyren tupac-system
	];

	# FLEXY (system)
	"./machines/flexy/secrets/flexy-ssh-ed25519-private.age".publicKeys = [
		kreyren kira flexy-system
	];
	"./machines/flexy/secrets/flexy-disks-password.age".publicKeys = [
		kreyren kira flexy-system
	];
	"./machines/flexy/secrets/flexy-onion.age".publicKeys = [
		kreyren kira flexy-system tupac-system sinnenfreude-system mracek-system
	];
	"./machines/flexy/secrets/flexy-onion-secretKey.age".publicKeys = [
		kreyren kira tupac-system
	];
	"./machines/flexy/secrets/flexy-onion-openssh-private.age".publicKeys = [
		kreyren kira flexy-system
	];

	# MRACEK (system)
	"./machines/mracek/secrets/mracek-disks-password.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-onion-gitea-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-openssh-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-onion-vikunja-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-vikunja-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-onion-monero-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-gitea-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-onion-murmur-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-monero-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-monero-p2p-onion.age".publicKeys = [
		kreyren
	] ++ all-systems; # Onion Address for Monero's P2P Onion Service

	"./machines/mracek/secrets/mracek-onion-monero-p2p-private.age".publicKeys = [
		kreyren mracek-system
	]; # Private Key for Monero's P2P Onion Service

	"./machines/mracek/secrets/mracek-murmur-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-onion-navidrome-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-navidrome-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/mracek/secrets/mracek-ssh-ed25519-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-onion-openssh-private.age".publicKeys = [
		kreyren mracek-system
	];

	"./machines/mracek/secrets/mracek-builder-ssh-ed25519-private.age".publicKeys = [
		kreyren mracek-system
	];

	# PELAGUS (system)
	"./machines/pelagus/secrets/disks-password.age".publicKeys = [
		kreyren pelagus-system
	];
	"./machines/pelagus/secrets/pelagus-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	# SINNENFREUDE (system)
	"./machines/sinnenfreude/secrets/sinnenfreude-disks-password.age".publicKeys = [
		kreyren sinnenfreude-system
	];

	"./machines/sinnenfreude/secrets/sinnenfreude-onion.age".publicKeys = [
		kreyren
	] ++ all-systems;

	"./machines/sinnenfreude/secrets/sinnenfreude-ssh-ed25519-private.age".publicKeys = [
		kreyren sinnenfreude-system
	];

	"./machines/sinnenfreude/secrets/sinnenfreude-onion-openssh-private.age".publicKeys = [
		kreyren sinnenfreude-system
	];

	"./machines/sinnenfreude/secrets/sinnenfreude-builder-ssh-ed25519-private.age".publicKeys = [
		kreyren sinnenfreude-system
	];

	# TSVETAN (system)
	"./machines/tsvetan/secrets/disks-password.age".publicKeys = [
		kreyren tsvetan-system
	];

	# TUPAC (system)
	"./machines/tupac/secrets/tupac-ssh-ed25519-private.age".publicKeys = [
		kreyren kira tupac-system
	];
	"./machines/tupac/secrets/tupac-disks-password.age".publicKeys = [
		kreyren kira tupac-system
	];
	"./machines/tupac/secrets/tupac-onion.age".publicKeys = [
		kreyren kira tupac-system sinnenfreude-system mracek-system
	];
	"./machines/tupac/secrets/tupac-onion-secretKey.age".publicKeys = [
		kreyren kira tupac-system
	];
	"./machines/tupac/secrets/tupac-onion-openssh-private.age".publicKeys = [
		kreyren kira tupac-system
	];

	"./machines/tupac/secrets/tupac-builder-ssh-ed25519-private.age".publicKeys = [
		kreyren kira tupac-system
	];

	# WiFi
	"./modules/system/wifi/homeBaseKreyren-WiFi-PSK.age".publicKeys = [
		kreyren kira
	] ++ all-systems;
}
