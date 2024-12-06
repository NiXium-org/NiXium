{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.tools.inputs = [
		homeManagerModules.tools-direnv
		homeManagerModules.tools-git
		homeManagerModules.web-browsers
	];

	imports = [
		./direnv
		./git
	];
}
