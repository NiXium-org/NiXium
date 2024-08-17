{ config, lib, ... }:

# Used to outsource nix's build requirements across available systems in the network, on slow devices such as tablets and battery limited devices such as drones this is essential to configure otherwise nix will drain battery and resources from them
#
# Reference: https://nixos.wiki/wiki/Distributed_build

let
	inherit (lib) mkIf;
in mkIf config.nix.distributedBuilds {
	# DNM(Krey): Set to 1 for debugging
	nix.settings.max-jobs = 1; # Do not perform any nix builds on tsvetan if distributed builds are enabled

	# Authorize TUPAC
		users.extraUsers.builder.openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBSPCMXZ6377AeL5ZKdv7Y041CIJ2lhKl/YH/tbY7xc" # TUPAC
		];

	# Set up the Build Account
		# Import the SSH Keys for the builder account
		age.secrets.tsvetan-builder-ssh-ed25519-private = {
			file = ../secrets/tsvetan-builder-ssh-ed25519-private.age;

			owner = "builder";
			group = "builder";
			mode = "400"; # r--------

			path = (if config.boot.impermanence.enable
				then "/nix/persist/system/etc/ssh/ssh_builder_ed25519_key"
				else "/etc/ssh/ssh_builder_ed25519_key");

			symlink = false; # Appears to not work as symlink
		};

		# Set the pubkey
		environment.etc."ssh/ssh_builder_ed25519_key.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3Zr7TFTxa1jKrTl/R5wMDTr9WtmTzgmc7NUnRjUKaD root@tsvetan";

		# Impermanence
		environment.persistence."/nix/persist/system".files = mkIf config.boot.impermanence.enable [
			"/etc/ssh/ssh_builder_ed25519_key" # Builder account for distributed builds
		];

	nix = {
		buildMachines = [
			{
				# SINNENFREUDE
				hostName = "sinnenfreude.systems.nx";
				systems = [ "x86_64-linux" "aarch64-linux" ];
				protocol = "ssh-ng";

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshUser = "builder";
				# sshUser = builder-account;

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshKey = "/etc/ssh/ssh_builder_ed25519_key";
				#sshKey = "${builder-key-path}/ssh_${builder-account}_ed25519_key";

				maxJobs = 8; # 100%, 16GB RAM available
				speedFactor = 2;
				supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
				mandatoryFeatures = [ ];
			}
			{
				# MRACEK
				hostName = "mracek.systems.nx";
				systems = [ "x86_64-linux" "aarch64-linux" ];
				protocol = "ssh-ng";

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshUser = "builder";
				# sshUser = builder-account;

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshKey = "/etc/ssh/ssh_builder_ed25519_key";
				#sshKey = "${builder-key-path}/ssh_${builder-account}_ed25519_key";

				maxJobs = 2; # 50% of system resources
				speedFactor = 1;
				supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
				mandatoryFeatures = [ ];
			}
			{
				# TUPAC
				hostName = "tupac.systems.nx";
				systems = [ "x86_64-linux" "aarch64-linux" ];
				protocol = "ssh-ng";

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshUser = "builder";
				# sshUser = builder-account;

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshKey = "/etc/ssh/ssh_builder_ed25519_key";
				#sshKey = "${builder-key-path}/ssh_${builder-account}_ed25519_key";

				maxJobs = 2; # 50% of system resources
				speedFactor = 2;
				supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
				mandatoryFeatures = [ ];
			}
		];
	};
}
