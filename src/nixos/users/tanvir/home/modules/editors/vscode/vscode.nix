{ config, lib, pkgs, ... }:

# Tanvir's configuration of vscode/vscodium

let
	inherit (lib) mkForce mkIf;
in mkIf config.programs.vscode.enable {
	programs.vscode = {
		package = pkgs.vscodium;
		# FIXME(Krey): This should be set to false by default
		enableExtensionUpdateCheck = mkForce false; # Enforce purity
		enableUpdateCheck = false;
		userSettings = {
			# Zoom with mouse wheel
			"editor.mouseWheelZoom" = true;

			# Highlight invisible characters
			"editor.renderWhitespace" = "all";

			"window.zoomLevel" = 2;

			# Set Theme
			# FIXME(Krey): Needs to be packaged
			#"workbench.colorTheme" = "Shades of Purple (Super Dark)";
		};
	};
}
