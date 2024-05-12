# Standard NixOS filesystem management of TUPAC with separate /nix

{
	# FIXME(Krey): Figure out what these are
	boot.initrd.luks.devices = {
		"luks-ef36ba32-afaa-4538-9ea5-6c583a4bcbf6".device = "/dev/disk/by-uuid/ef36ba32-afaa-4538-9ea5-6c583a4bcbf6";

		"luks-8dbce289-0c7d-4421-9144-7aab4fc10095".device = "/dev/disk/by-uuid/8dbce289-0c7d-4421-9144-7aab4fc10095";
	};

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/6b3d4148-e307-4a42-b121-74a4928634cc";
			fsType = "btrfs";
			options = [ "subvol=@" ];
		};

		"/boot" = {
			device = "/dev/disk/by-uuid/CED8-0535";
			fsType = "vfat"; # FAT32
		};

		"/nix" = {
			device = "/dev/disk/by-uuid/879e527b-e696-4c31-a31a-81353014808a";
			fsType = "btrfs";
		};
	};

	swapDevices =
		[ { device = "/dev/disk/by-uuid/0b3f6282-b47c-4b82-95a0-27be9989a556"; }
		];
}
