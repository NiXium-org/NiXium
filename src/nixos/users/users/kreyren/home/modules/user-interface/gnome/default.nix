{
	flake.homeManagerModules.ui-gnome-kreyren = ./gnome.nix;

	imports = [
		./extensions
	];
}
