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
			# Keep this sorted
			imports = [
				nixosModules.programs-git
				nixosModules.programs-wakeonlan

				nixosModules.security
				nixosModules.security-nvidia

				nixosModules.services-distributedBuilds
				nixosModules.services-monero
				nixosModules.services-sshd
				nixosModules.services-tor

				nixosModules.system-bootloader
				nixosModules.system-ccache
				nixosModules.system-clamav
				nixosModules.system-docker
				nixosModules.system-environment
				nixosModules.system-firewall
				nixosModules.system-impermenance
				nixosModules.system-kernel
				nixosModules.system-lanzaboote
				nixosModules.system-locale
				nixosModules.system-nix
				nixosModules.system-release
				nixosModules.system-time
				nixosModules.system-wifi

				# DNM(Krey): For some reason MORPH is not declared in secrets.nix likely made a mistake during rebase somewhere -> Fix it prior to merge
				# nixosModules.machine-morph
				nixosModules.machine-mracek
				nixosModules.machine-sinnenfreude
				nixosModules.machine-tupac

				# {
				# 	sops.defaultSopsFile = ./.sops.yaml;
				# }
			];
		}
	);

	imports = [
		./machines
		./modules
		./users
	];
}
