{ lib, pkgs, ... }:

let
	inherit (lib) mkForce;
in {
	programs.vscode = {
		package = pkgs.vscodium;
		enableExtensionUpdateCheck = mkForce false; # Enforce purity
		enableUpdateCheck = false;
		extensions = with pkgs.vscode-extensions; [
			editorconfig.editorconfig
			mkhl.direnv
			jnoortheen.nix-ide
			oderwat.indent-rainbow
			# FIXME(Krey): Needs to be packages
			#edwinhuish.better-comments-next
			# FIXME(Krey): Needs to be packages
			#ahmadawais.shades-of-purple
			# FIXME(Krey): Needs management as it blocks TOR
			#shyykoserhiy.vscode-spotify
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
