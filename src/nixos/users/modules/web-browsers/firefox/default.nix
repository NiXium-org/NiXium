# { moduleWithSystem, ... }:

# {
# 	flake.homeManagerModules.web-browsers-firefox-kreyren = moduleWithSystem (
# 		perSystem@{ config }:
# 		{
# 			# services.foo.package = perSystem.config.packages.foo;
# 			imports = [ ./firefox.nix ];
# 		}
# 	);
# }


# NOTE(Krey): Old declaration
{
	flake.homeManagerModules.web-browsers-firefox = ./firefox.nix;
}
