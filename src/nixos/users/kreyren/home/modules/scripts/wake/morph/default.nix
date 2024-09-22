{ pkgs, ... }:

let
	inherit (builtins) readFile;
in {
	home.file.".local/bin/wake.morph" = {
		text = pkgs.writeShellApplication {
			name = "nixos-morph-stable-install";
			bashOptions = [
				"errexit" # Exit on False Return
				"posix" # Run in POSIX mode
			];
			runtimeInputs = [ ];
			runtimeEnv = { };
			text = readFile ./wake-morph.sh;
		};
		executable = true; # Make the script executable
	};
}
