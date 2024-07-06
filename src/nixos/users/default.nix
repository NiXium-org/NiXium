{ config, ... }:

let
	inherit (config.flake) nixosModules;
in {
	flake.nixosModules.users.imports = [
		nixosModules.users-kreyren
		nixosModules.users-kira
		nixosModules.users-tanvir
	];

	imports = [
		./kreyren
		./kira
		./tanvir
	];
}
