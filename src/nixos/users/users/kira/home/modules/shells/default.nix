{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.shells-kreyren.imports = [
	# 	homeManagerModules.kreyren.shells.bash
	# 	homeManagerModules.kreyren.shells.nushell
	# ];

	imports = [
		./bash
		./nushell
	];
}
