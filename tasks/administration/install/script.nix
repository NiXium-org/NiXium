{ inputs, ... }:

# Task to INSTALL the specified derivation on current system including the firmware in a fully declarative way

# Refer to https://github.com/nix-community/disko/issues/657#issuecomment-2146978563 for implementation notes

{
	perSystem = { system, pkgs, inputs', ... }: {
		apps.install-task.program = pkgs.writeShellApplication {
			name = "install-task";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = (builtins.readFile ./script.sh);
		};
	};
}

