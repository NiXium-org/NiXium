{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.tanvir.tools.default.imports = [
	# 	homeManagerModules.tanvir.tools.direnv
	# 	homeManagerModules.tanvir.tools.git
	# 	homeManagerModules.tanvir.tools.gpg-agent
	# ];

	imports = [
		./direnv
		./git
		./gpg-agent
	];
}
