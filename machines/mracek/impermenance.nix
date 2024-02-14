{ lib, config, ... }:

# Independent module providing impermenance mode for the MRACEK system

let
	inherit (lib) mkIf;
in {
	boot.initrd.luks.devices = {
		"luks-3f91458d-a1a5-4351-a422-1470844800f2" = {
			device = "/dev/disk/by-uuid/3f91458d-a1a5-4351-a422-1470844800f2"; # Nix-store
		};
		"luks-a3a28fb8-883c-404a-a312-cc20bf9e9890" = {
			device = "/dev/disk/by-uuid/a3a28fb8-883c-404a-a312-cc20bf9e9890"; # SWAP
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

		"/home/raptor" = {
			device = "none";
			fsType = "tmpfs";
			options = [ "size=4G" "mode=777" ];
		};

		"/nix" = {
			device = "/dev/disk/by-label/NIX";
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
			(mkIf config.boot.lanzaboote.enable "/etc/secureboot")
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
