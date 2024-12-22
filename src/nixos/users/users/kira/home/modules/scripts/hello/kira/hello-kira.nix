{ pkgs, ... }:

let
	inherit (builtins) readFile;
in {
	home.file.".local/bin/hello.kira" = {
		target = ".local/bin/hello.kira";
		source = "${pkgs.writeShellApplication {
			name = "hello.kira";
			bashOptions = [
				"errexit" # Exit on False Return
				"posix" # Run in POSIX mode
			];
			runtimeInputs = [
				pkgs.openssh # To perform the SSH call
			];
			runtimeEnv = {
				targetMAC = "e0:d5:5e:82:ef:ba"; # MAC Address of The Target Device
			};
			text = readFile ./hello-kira.sh;
		}}/bin/hello.kira";
		executable = true; # Make the script executable
	};
}
