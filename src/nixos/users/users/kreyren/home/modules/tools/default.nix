{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.kreyren.tools.default.imports = [
	# 	homeManagerModules.kreyren.tools.direnv
	# 	homeManagerModules.kreyren.tools.git
	# 	homeManagerModules.kreyren.tools.gpg-agent
	# ];

	imports = [
		./git
		./gpg-agent
		./ragenix
	];
}
