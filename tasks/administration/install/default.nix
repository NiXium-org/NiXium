{ pkgs, inputs, ... }:

# The Install Task is used to deploy a new system via disko-install

# WARNING: This task will cause a data loss unless the configuration is 100% declarative including the persistent files

{
	imports = [ ./script.nix ];
	# perSystem = {
	# 	mission-control.scripts = {
	# 		"install" = {
	# 			description = "Perform full declarative reinstallation of SYSTEM on a set DISK";
	# 			category = "Administration";
	# 			# FIXME-QA(Krey): This makes the declaration more functional, but looks like an ugly hack
	# 			exec = toString ((import ./script.nix { inherit pkgs inputs; }).install-task + /bin/install-task);
	# 		};
	# 	};
	# };
}
