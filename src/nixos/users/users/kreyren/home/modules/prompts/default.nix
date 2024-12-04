{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.prompts-kreyren.inputs = [
		homeManagerModules.prompts-starship-kreyren
	];

	imports = [
		./starship
	];
}
