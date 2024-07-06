# { moduleWithSystem, ... }:

# {
# 	flake.homeManagerModules.web-browsers-firefox-tanvir = moduleWithSystem (
# 		perSystem@{ config }:
# 		{
# 			# services.foo.package = perSystem.config.packages.foo;
# 			imports = [ ./firefox.nix ];
# 		}
# 	);
# }


# NOTE(Krey): Old declaration
{
	flake.homeManagerModules.web-browsers-firefox-tanvir = ./firefox.nix;
}
