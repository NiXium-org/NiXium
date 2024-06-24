{ ... }:

# The BUILD Task

{
	perSystem = { pkgs, ... }: {
		mission-control.scripts = {
			"build" = {
				description = "Build and cache the system configuration without deployment";
				category = "Administration";
				# FIXME-QA(Krey): This makes the declaration more functional, but looks like an ugly hack
				exec = toString ((import ./script.nix { inherit pkgs; }).build-task + /bin/build-task);
			};
		};
	};
}
