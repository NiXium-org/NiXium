{ lib, pkgs, ... }:

let
	inherit (lib) mkForce;
in {
	programs.vscode = {
		package = pkgs.vscodium;

		# Which Extensions to include
		extensions = with pkgs.vscode-extensions; [
			editorconfig.editorconfig
			mkhl.direnv
			jnoortheen.nix-ide
			oderwat.indent-rainbow
		];
		userSettings = {
			# Zoom with mouse wheel
			"editor.mouseWheelZoom" = true;

			# Highlight invisible characters
			"editor.renderWhitespace" = "all";

			"window.zoomLevel" = 2;

			# Set Theme
			## FIXME(Krey): Needs to be packaged
			#"workbench.colorTheme" = "Shades of Purple (Super Dark)";
		};
	};
}
