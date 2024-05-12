{ lib, config, ... }:

# Independent module providing impermenance mode for the MRACEK system

let
	inherit (lib) mkIf;
in {
	boot.initrd.luks.devices = {
		"luks-e9a7bbe8-0075-44af-82cd-7ebfd68fd28f" = {
			device = "/dev/disk/by-uuid/e9a7bbe8-0075-44af-82cd-7ebfd68fd28f"; # Nix-store?
		};
		"luks-70afb75c-8ade-4372-a127-915e3a06356d" = {
			device = "/dev/disk/by-uuid/70afb75c-8ade-4372-a127-915e3a06356d"; # SWAP
		};
	};

	boot.tmp.useTmpfs = true; # Mounts a /tmp filesystem on tmpfs (https://matrix.to/#/!KqkRjyTEzAGRiZFBYT:nixos.org/$DR9utkk4dHQ7iIWMfuVhKSymx5_9HRteEewVONBry2c?via=nixos.org)
	boot.tmp.tmpfsSize = "100%"; # How much of the RAM's total size do we want to use?
	boot.tmp.cleanOnBoot = false; # False is default, unsure what it does in impermenance context

	# Filesystem Management
	fileSystems = {
		"/" = {
			device = "none";
			fsType = "tmpfs";
			options = [ "size=3G" "mode=755" ];
		};

		# "/home/raptor" = {
		# 	device = "none";
		# 	fsType = "tmpfs";
		# 	options = [ "size=4G" "mode=777" ];
		# };

		"/nix" = {
			device = "/dev/disk/by-label/NIX_STORE";
			fsType = "btrfs";
		};

		"/boot" = {
			device = "/dev/disk/by-label/BOOT";
			fsType = "vfat"; # FAT32
		};
	};

	swapDevices = [
		{ device = "/dev/disk/by-label/SWAP"; }
	];

	# Impermanence
	environment.persistence."/nix/persist/system" = {
		hideMounts = true;
		directories = [
			"/var/log" # Logs
			"/var/lib/bluetooth" # Keep bluetooth configs
			"/var/lib/nixos" # Nix stuff
			"/var/lib/systemd/coredump" # Dunno
			"/etc/NetworkManager/system-connections" # WiFi configs

			(mkIf config.boot.lanzaboote.enable config.boot.lanzaboote.pkiBundle) # Lanzaboote

			(mkIf config.services.monero.enable config.services.monero.dataDir) # Monero

			# Vikunja
				# FIXME-UPSTREAM(Krey): The `config.services.vikunja.database.path` points to the vikunja.db while there is also `files` directory that holds images, but the nix definition doesn't provide a thing that can be used that will store the state directory's path
				# FIXME-UPSTREAM(Krey): It's also a symlink to /var/lib/private/vikunja for some reason.. bullshit
				# (mkIf config.services.vikunja.enable config.services.vikunja.database.path) # Vikunja
					"/var/lib/private/vikunja"

			(mkIf config.services.tor.enable (config.services.tor.settings.DataDirectory + "/onion")) # Tor services

			{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
		];
		files = [
			{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
			"/etc/machine-id"
			"/etc/ssh/ssh_host_ed25519_key"
			"/etc/ssh/ssh_host_ed25519_key.pub"
		];
	};
}
