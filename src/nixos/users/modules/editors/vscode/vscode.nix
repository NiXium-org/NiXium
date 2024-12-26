{ config, lib, pkgs, ... }:

let
	inherit (lib) mkDefault mkForce mkIf;
in mkIf config.programs.vscode.enable {
	programs.vscode = {
		package = mkDefault pkgs.vscodium;

		# Purity Enforcement
		enableExtensionUpdateCheck = false;
		enableUpdateCheck = false;

		# Extensions to install by default, can be overwritten by the user
		extensions = with pkgs.vscode-extensions; [
			editorconfig.editorconfig
			mkhl.direnv
			jnoortheen.nix-ide
			oderwat.indent-rainbow
			# FIXME(Krey): Needs to be packages
			#edwinhuish.better-comments-next
		];
		userSettings = {
			"editor.mouseWheelZoom" = true; # Zoom with mouse wheel
			"editor.renderWhitespace" = "all"; # Highlight invisible characters
		};
	};
}
