{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.shells-tanvir.imports = [
	# 	homeManagerModules.tanvir.shells.bash
	# 	homeManagerModules.tanvir.shells.nushell
	# ];

	imports = [
		./bash
		./nushell
	];
}
