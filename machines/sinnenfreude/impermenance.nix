# This is an experimental declaration of an impermenance setup on SINNENFREUDE to better understand it's practical challenges and figure out management

{
	boot.initrd.luks.devices."luks-c61bb824-f4b5-409c-b083-b5e11e2d9cc5".device = "/dev/disk/by-uuid/c61bb824-f4b5-409c-b083-b5e11e2d9cc5"; # Nix-Store
	boot.initrd.luks.devices."luks-4c0cf623-043a-4dbd-a85b-6f9af34a136a".device = "/dev/disk/by-uuid/4c0cf623-043a-4dbd-a85b-6f9af34a136a"; # SWAP

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

		# As suggested in https://matrix.to/#/!KqkRjyTEzAGRiZFBYT:nixos.org/$ebUToAwh1VJhOKWawWq46WLD4FfZghupcApulGWEb_E (https://github.com/NixOS/nixpkgs/blob/cfc3698c31b1fb9cdcf10f36c9643460264d0ca8/nixos/modules/system/boot/tmp.nix#L51)
		# "/tmp" = {
		# 	device = "none";
		# 	fsType = "tmpfs";
		# 	options = [ "size=14G" "mode=755" ];
		# };

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
			{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
		];
		files = [
			"/etc/machine-id"
			{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
			"/etc/ssh/ssh_host_ed25519_key"
			"/etc/ssh/ssh_host_ed25519_key.pub"
		];
	};
}
