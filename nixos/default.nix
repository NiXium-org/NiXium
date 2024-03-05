{ config, ... }:

let
	inherit (config.flake) nixosModules;
in {
	flake.nixosModules.default.imports = [
		nixosModules.system-nix
		nixosModules.system-time
		nixosModules.system-ccache
		nixosModules.system-clamav
		nixosModules.services-tor
		nixosModules.services-vikunja
	];

	imports = [
		./modules
		./users
	];
}
