# { moduleWithSystem, ... }:

# {
# 	flake.homeManagerModules.web-browsers-firefox-kira = moduleWithSystem (
# 		perSystem@{ config }:
# 		{
# 			# services.foo.package = perSystem.config.packages.foo;
# 			imports = [ ./firefox.nix ];
# 		}
# 	);
# }


# NOTE(Krey): Old declaration
{
	flake.homeManagerModules.web-browsers-firefox-kira = ./firefox.nix;
}
