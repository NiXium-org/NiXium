{ config, ... }:

let
	inherit (config.flake) nixosModules;
in {
	flake.nixosModules.default.imports = [
		nixosModules.system-autoUpgrade
		nixosModules.system-nix
		nixosModules.system-time
		nixosModules.system-ccache
		nixosModules.system-clamav
		nixosModules.services-tor
		nixosModules.services-vikunja
		nixosModules.services-distributedBuilds
		{
			environment.localBinInPath = true; # Include ~/.local/bin in PATH
		}
	];

	imports = [
		./modules
		./users
	];
}
