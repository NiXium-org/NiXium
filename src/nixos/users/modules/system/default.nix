{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.system.inputs = [
		homeManagerModules.system-nix
	];

	imports = [
		./nix
	];
}
