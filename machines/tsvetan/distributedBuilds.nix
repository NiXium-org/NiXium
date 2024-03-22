{ config, lib, ... }:

# Used to outsource nix's build requirements across available systems in the network, on slow devices such as tablets and battery limited devices such as drones this is essential to configure otherwise nix will drain battery and resources from them
#
# Reference: https://nixos.wiki/wiki/Distributed_build

let
	inherit (lib) mkIf;
in {
	nix.settings.max-jobs = mkIf config.nix.distributedBuilds 0; # Do not perform any nix builds on tsvetan if distributed builds are enabled

	# SECURITY(Krey): CONFIDENTIAL URLS
	# FIXME(Krey): Should be declared separately
	# services.tor.settings = {
	# 	"MapAddress" = [
	# 		"dreamon.nixium stuff.onion"
	# 		"cajzl.nixium stuff.onion"
	# 		"acer.nixium stuff.onion"
	# 	];
	# };

	nix = {
		buildMachines = [
			{
				# SINNENFREUDE
				# FIXME(Krey): Use onion service
				#hostName = "sinnenfreude.nixium";
				hostName = "192.168.0.17";
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
				# PELAGUS
				# FIXME(Krey): Use onion service
				#hostName = "pelagus.nixium";
				hostName = "192.168.0.206";
				systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];
				protocol = "ssh-ng";

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshUser = "builder";
				# sshUser = builder-account;

				# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
				sshKey = "/etc/ssh/ssh_builder_ed25519_key";
				#sshKey = "${builder-key-path}/ssh_${builder-account}_ed25519_key";

				maxJobs = 2; # 4 GB of RAM available
				speedFactor = 2;
				supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
				mandatoryFeatures = [ ];
			}
			# {
			# 	# MRACEK
			# 	# FIXME(Krey): Use onion service
			# 	#hostName = "mracek.nixium";
			# 	hostName = "192.168.0.88";
			# 	systems = [ "x86_64-linux" "aarch64-linux" ];
			# 	protocol = "ssh-ng";

			# 	# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
			# 	sshUser = "builder";
			# 	# sshUser = builder-account;

			# 	# FIXME-QA(Krey): Set this as a variable from nixos/modules/distributedBuilds
			# 	sshKey = "/etc/ssh/ssh_builder_ed25519_key";
			# 	#sshKey = "${builder-key-path}/ssh_${builder-account}_ed25519_key";

			# 	maxJobs = 8; # 100%, 16GB RAM available
			# 	speedFactor = 2;
			# 	supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			# 	mandatoryFeatures = [ ];
			# }
		];
	};
}
