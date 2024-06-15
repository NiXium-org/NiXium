# Task to update the flake locks

{
	mission-control.scripts = {
		generator-tor-key = {
			description = "Output private and public keys for tor service";
			category = "Management";
			exec = "${./script.sh}";
		};
	};
}
