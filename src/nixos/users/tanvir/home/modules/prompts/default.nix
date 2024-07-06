{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.prompts-tanvir.inputs = [
		homeManagerModules.prompts-starship-tanvir
	];

	imports = [
		./starship
	];
}
