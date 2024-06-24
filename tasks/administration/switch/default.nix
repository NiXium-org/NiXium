{ ... }:

# The SWITCH Task

{
	perSystem = { pkgs, ... }: {
		mission-control.scripts = {
			"switch" = {
				description = "Switch the configuration on the current supported system or specified";
				category = "Administration";
				# FIXME-QA(Krey): This makes the declaration more functional, but looks like an ugly hack
				exec = toString ((import ./script.nix { inherit pkgs; }).switch-task + /bin/switch-task);
			};
		};
	};
}
