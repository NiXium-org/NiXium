# Task to update the flake locks

{
	mission-control.scripts = {
		update = {
			description = "Update the Flake Lock";
			category = "Management";
			exec = "${./script.sh}";
		};
	};
}
