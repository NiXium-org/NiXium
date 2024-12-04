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

			keyboard.bindings = [
					{	mods = "Control"; key = "Plus"; action = "IncreaseFontSize"; }
					{	mods = "Control"; key = "Minus"; action = "DecreaseFontSize"; }
					{	mods = "Control"; key = "Equals"; action = "ResetFontSize"; }
			];
		};
	};
}
