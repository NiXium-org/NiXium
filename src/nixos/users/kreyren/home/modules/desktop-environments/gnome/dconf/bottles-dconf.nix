{ lib, pkgs, ... }:

# Kreyren's Management of Bottles Application

{
	dconf.settings = {
		"com/usebottles/bottles" = {
			auto-close-bottles = true;
			release-candidate = true;
			experiments-sandbox = true;
			steam-proton-support = true;
		};
	};
}
