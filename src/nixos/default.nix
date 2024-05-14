{ config, moduleWithSystem, ... }:

# Management of NixOS systems

let
	inherit (config.flake) nixosModules;
in {

# {
# 	flake.homeManagerModules.web-browsers-firefox-kreyren = moduleWithSystem (
# 		perSystem@{ config }:
# 		{
# 			# services.foo.package = perSystem.config.packages.foo;
# 			imports = [ ./firefox.nix ];
# 		}
# 	);
# }

	flake.nixosModules.default = moduleWithSystem (
		perSystem@{ system }:
		{ ... }:
		{
			imports = [
				nixosModules.system-autoUpgrade
				nixosModules.system-nix
				nixosModules.system-time
				nixosModules.system-locale
				nixosModules.system-ccache
				nixosModules.system-clamav
				nixosModules.system-ssh
				nixosModules.services-tor
				nixosModules.services-vikunja
				nixosModules.services-distributedBuilds
				# nixosModules.security-cve-2024-3094

				# nixosModules.machine-pelagus

				# {
				# 	sops.defaultSopsFile = ./.sops.yaml;
				# }

				nixosModules.programs-git
				{
					environment.localBinInPath = true; # Include ~/.local/bin in PATH
				}
			];
		}
	);

	imports = [
		./machines
		./modules
		./users
	];
}
