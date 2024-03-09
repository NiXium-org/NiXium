{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.prompts-kira.inputs = [
		homeManagerModules.prompts-starship-kreyren
	];

	imports = [
		./starship
	];
}
