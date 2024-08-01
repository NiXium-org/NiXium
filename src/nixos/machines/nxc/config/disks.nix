{ config, lib, ... }:

# Nix-based Disk Management of NXC with disko and impermenance on tmpfs

# Formatting strategy (Impermanence):
#    TBD

# Formatting strategy (WITHOUT impermanence):
#    TBD

let
	inherit (lib) mkMerge;

	diskoDevice = "/dev/vda";

	# FIXME(Krey): Currently pending management to perform remote-unlock over Tor (https://github.com/NiXium-org/NiXium/issues/55)
	performFullDiskEncryption = false; # Whether we should perform full disk encryption
in mkMerge [
	{
		# Declare the disk encryption key, has to be always defined for evaluation to not fail
		age.secrets.nxc-disks-password.file = ../secrets/nxc-disks-password.age; # Supply password for disk encryption
	}

	# FIXME(Krey): Causes infinite recursion, no idea why
	# (if (config.boot.impermenance.enable == true) then {
	(if (true) then {
		age.identityPaths = [ "/nix/persist/system/etc/ssh/ssh_host_ed25519_key" ]; # Change the identity path to use our disko path

		fileSystems."/nix/persist/system".neededForBoot = true;

		# FIXME(Krey): Figure out how to do labels
		disko.devices = {
			nodev."/" = {
				fsType = "tmpfs";
				mountOptions = [
					"size=6G"
					"defaults"
					"mode=755"
				];
			};

			disk = {
				system = {
					device = diskoDevice;
					type = "disk";
					imageSize = "30G"; # Size of the generated image
					content = {
						type = "gpt";
						partitions = {

							boot = {
								priority = 1; # Needs to be first partition
								type = "EF00"; # EFI System Partition/
								size = "512M";
								content = {
									type = "filesystem";
									format = "vfat"; # FAT32
									mountpoint = "/boot";
								};
							};

							store = (if performFullDiskEncryption
								then {
									priority = 3;
									size = "100%";
									content = {
										name = "store";
										type = "luks";
										settings.allowDiscards = true;

										passwordFile = config.age.secrets.nxc-disks-password.path;

										initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

										extraFormatArgs = [
											"--use-random" # use true random data from /dev/random, will block until enough entropy is available
											"--label=CRYPT_NIX"
										];

										extraOpenArgs = [
											"--timeout 10"
										];

										content = {
											type = "btrfs";
											extraArgs = [ "--label NIX_STORE" ];
											subvolumes = {
												"@nix" = {
													mountpoint = "/nix";
													mountOptions = [ "compress=lzo" "noatime" ];
												};
												"@persist" = {
													mountpoint = "/nix/persist/system";
													mountOptions = [ "compress=lzo" "noatime" ];
												};
											};
										};
									};
								}	else {
									priority = 3;
									size = "100%";
									content = {
										type = "btrfs";
										extraArgs = [ "-f" ]; # Override existing partition

										subvolumes = {
											"$@nix" = {
												mountpoint = "/nix";
												mountOptions = [ "compress=lzo" "noatime" ];
											};
											"@persist" = {
												mountpoint = "/nix/persist/system";
												mountOptions = [ "compress=lzo" "noatime" ];
											};
										};
									};
								});

							swap = (if performFullDiskEncryption
								then {
									priority = 2;
									size = "30G";
									content = {
										name = "swap";
										type = "luks";

										settings.allowDiscards = true;

										passwordFile = config.age.secrets.nxc-disks-password.path;

										initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

										extraFormatArgs = [
											"--use-random" # use true random data from /dev/random, will block until enough entropy is available
											"--label=CRYPT_SWAP"
										];

										extraOpenArgs = [
											"--timeout 10"
										];

										content = {
											type = "swap";
											resumeDevice = true; # resume from hiberation from this device

											extraArgs = [
												"--label SWAP"
											];
										};
									};
								} else {
									priority = 2;
									size = "30G";

									content = {
										type = "swap";
										resumeDevice = true; # resume from hiberation from this device

										extraArgs = [
											"--label SWAP"
										];
									};
								});
							};
						};
						};
					};
				};
	} else {
		age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ]; # Change the identity path to use our disko path

		disk = {
			system = {
				device = diskoDevice;
				type = "disk";
				imageSize = "50G"; # Size of the generated image
				content = {
					type = "gpt";
					partitions = {

						boot = {
							priority = 1; # Needs to be first partition
							type = "EF00"; # EFI System Partition/
							size = "512M";
							content = {
								type = "filesystem";
								format = "vfat"; # FAT32
								mountpoint = "/boot";
							};
						};

						store = (if performFullDiskEncryption
							then {
								priority = 3;
								size = "100%";
								content = {
									name = "store";
									type = "luks";
									settings.allowDiscards = true;

									passwordFile = config.age.secrets.nxc-disks-password.path;

									initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

									extraFormatArgs = [
										"--use-random" # use true random data from /dev/random, will block until enough entropy is available
										"--label=CRYPT_NIX"
									];

									extraOpenArgs = [
										"--timeout 10"
									];

									content = {
										type = "btrfs";
										extraArgs = [ "--label NIX_STORE" ];
										subvolumes = {
											"@nix" = {
												mountpoint = "/nix";
												mountOptions = [ "compress=lzo" "noatime" ];
											};
											"@persist" = {
												mountpoint = "/nix/persist/system";
												mountOptions = [ "compress=lzo" "noatime" ];
											};
										};
									};
								};
							} else {
								priority = 3;
								size = "100%";
								content = {
									type = "btrfs";
									extraArgs = [ "-f" ]; # Override existing partition

									subvolumes = {
										"$@nix" = {
											mountpoint = "/nix";
											mountOptions = [ "compress=lzo" "noatime" ];
										};
									};
								};
							});

						swap = (if performFullDiskEncryption
							then {
								priority = 2;
								size = "30G";
								content = {
									name = "swap";
									type = "luks";

									settings.allowDiscards = true;

									passwordFile = config.age.secrets.nxc-disks-password.path;

									initrdUnlock = true; # Add a boot.initrd.luks.devices entry for the specified disk

									extraFormatArgs = [
										"--use-random" # use true random data from /dev/random, will block until enough entropy is available
										"--label=CRYPT_SWAP"
									];

									extraOpenArgs = [
										"--timeout 10"
									];

									content = {
										type = "swap";
										resumeDevice = true; # resume from hiberation from this device

										extraArgs = [
											"--label SWAP"
										];
									};
								};
							} else {
								priority = 2;
								size = "30G";

								content = {
									type = "swap";
									resumeDevice = true; # resume from hiberation from this device

									extraArgs = [
										"--label SWAP"
									];
								};
							});
					};
				};
			};
		};
	})
]
