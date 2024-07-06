{ inputs, self, ... }:

# Task to INSTALL the specified derivation on current system including the firmware in a fully declarative way

# WARNING: This task will cause a data loss unless the configuration is 100% declarative including the persistent files

# Refer to https://github.com/nix-community/disko/issues/657#issuecomment-2146978563 for implementation notes

{
	perSystem = { system, pkgs, inputs', self', ... }: {
		# # Make this callable from `nix run`
		# apps.install-task.program = self'.packages.install-task;

		# # Package Declaration
		# packages.install-task = pkgs.writeShellApplication {
		# 	name = "install-task";
		# 	runtimeInputs = [
		# 		inputs'.disko.packages.disko-install
		# 		pkgs.age
		# 	];
		# 	text = (builtins.readFile ./script.sh);
		# };

		# Integration in mission-control
		mission-control.scripts = {
			"install" = {
				description = "Perform full declarative reinstallation of SYSTEM on a set DISK";
				category = "Administration";
				exec = ''
					distribution="$1"
					system="$2"

					die() { printf "FATAL: %s/n" "$2"; exit ;}

					# Input check
					[ -n "$distribution" ] || die 1 "First Argument (distribution) is required for the install task"
					[ -n "$system" ] || die 1 "Second Argument (system) is required for the install task"

					echo "WARNING: This action will wipe all data on the target device and performs full declarative re-installation!"

					# Perform the task
					nix --extra-experimental-features 'nix-command flakes' run ".#packages.x86_64-linux.$distribution-$system-install" -- "$system"
				'';
			};
		};
	};
}

