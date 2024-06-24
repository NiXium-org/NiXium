{ ... }:

# The DEPLOY Task

{
	perSystem = { pkgs, ... }: {
		mission-control.scripts = {
			"deploy" = {
				description = "Deploy the configuration to all systems or specified";
				category = "Administration";
				# FIXME-QA(Krey): This makes the declaration more functional, but looks like an ugly hack
				exec = toString ((import ./script.nix { inherit pkgs; }).deploy-task + /bin/deploy-task);
			};
		};
	};
}
