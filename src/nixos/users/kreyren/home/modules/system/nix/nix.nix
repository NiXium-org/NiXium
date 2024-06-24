{ pkgs, ... }:

{
	nix.extraOptions = builtins.concatStringsSep "\n" [
		"extra-experimental-features = nix-command flakes"
	];
}
