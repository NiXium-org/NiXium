{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kreyren.shells.default.imports = [
		homeManagerModules.kreyren.shells.bash
		homeManagerModules.kreyren.shells.nushell
	];

	imports = [
		./bash
		./nushell
	];
}
