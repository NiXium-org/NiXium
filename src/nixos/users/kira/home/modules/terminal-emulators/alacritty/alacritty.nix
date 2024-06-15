{ lib, pkgs, ... }:

# Common configuration of Alacritty

let
	inherit (lib) mkDefault;
in {
	programs.alacritty = {
		settings = {
			shell = {
				program = mkDefault "${pkgs.bashInteractive}/bin/bash";
			};

			key_binding = [
					{	mods = "Control"; key = "Plus"; action = "IncreaseFontSize"; }
					{	mods = "Control"; key = "Minus"; action = "DecreaseFontSize"; }
					{	mods = "Control"; key = "Equals"; action = "ResetFontSize"; }
			];
		};
	};
}
