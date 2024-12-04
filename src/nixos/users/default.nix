{ config, moduleWithSystem, ... }:

let
	inherit (config.flake) nixosModules;
in {
	# Home Modules used by all the users on demand
	flake.homeManagerModules.default = moduleWithSystem (
		perSystem@{ system }:
		{ ... }:
		{
			# Keep this sorted
			imports = [

				# {
				# 	sops.defaultSopsFile = ./.sops.yaml;
				# }
			];
		}
	);

	imports = [
		./users
		./modules
	];
}
