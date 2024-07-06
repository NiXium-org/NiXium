{ inputs, self, ... }:

# Task to INSTALL the specified derivation on current system including the firmware in a fully declarative way

# WARNING: This task will cause a data loss unless the configuration is 100% declarative including the persistent files

# Refer to https://github.com/nix-community/disko/issues/657#issuecomment-2146978563 for implementation notes

{
	perSystem = { system, pkgs, inputs', self', ... }: {
		# Make this callable from `nix run`
		apps.install-task.program = self'.packages.install-task;

		# Package Declaration
		packages.install-task = pkgs.writeShellApplication {
			name = "install-task";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = (builtins.readFile ./script.sh);
		};

		# Integration in mission-control
		mission-control.scripts = {
			"install" = {
				description = "Perform full declarative reinstallation of SYSTEM on a set DISK";
				category = "Administration";
				exec = ''
					echo "Inputs are: $*"

					${self'.packages.install-task}/bin/install-task

					echo ${self.nixosConfigurations.mracek.config.disko.devices.disk.system.device}
				'';
			};
		};
	};
}

