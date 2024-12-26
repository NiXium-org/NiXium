{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.scripts-kreyren.imports = [
		homeManagerModules.scripts-ssh-kreyren
		homeManagerModules.scripts-wake-kreyren
	];

	imports = [
		./ssh
		./wake
	];
}
