{ config, pkgs, lib, ... }:

# Plymouth management of IGNUCIUS

let
	inherit (lib) mkIf;
in mkIf config.boot.plymouth.enable {
	# BUG(Krey): Plymouth is currently broken and requires this fix: https://github.com/NixOS/nixpkgs/issues/332812
	nixpkgs.overlays = [
		(final: prev: {
			plymouth = prev.plymouth.overrideAttrs ({ src, ... }: {
				version = "24.004.60-unstable-2024-08-28";

				src = src.override {
					rev = "ea83580a6d66afd2b37877fc75248834fe530d99";
					hash = "sha256-GQzf756Y26aCXPyZL9r+UW7uo+wu8IXNgMeJkgFGWnA=";
				};
			});
		})
	];

	#boot.initrd.availableKernelModules = ["i915"];
	boot.kernelParams = [ "plymouth.use-simple-drm" ];

	boot.plymouth = {
		theme = "deus_ex";
		themePackages = [
			(pkgs.adi1090x-plymouth-themes.override {
				selected_themes = [ "deus_ex" ];
			})
		];
	};
}
