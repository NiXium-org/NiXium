{ pkgs, lib, config, ... }:

let
	inherit (lib) mkIf;

	# Wayland fix https://github.com/NixOS/nixpkgs/issues/292700#issuecomment-1974953531
	flameshotGrim = pkgs.flameshot.overrideAttrs (oldAttrs: {
		src = pkgs.fetchFromGitHub {
			owner = "flameshot-org";
			repo = "flameshot";
			rev = "3d21e4967b68e9ce80fb2238857aa1bf12c7b905";
			sha256 = "sha256-OLRtF/yjHDN+sIbgilBZ6sBZ3FO6K533kFC1L2peugc=";
		};
		cmakeFlags = [
			"-DUSE_WAYLAND_CLIPBOARD=1"
			"-DUSE_WAYLAND_GRIM=1"
		];
		buildInputs = oldAttrs.buildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
	});
in mkIf config.services.flameshot.enable {
	services.flameshot.package = flameshotGrim; # Set the patched flameshot as our flameshot

	# Workaround for Unit tray.target required by flameshot (https://github.com/nix-community/home-manager/issues/2064)
	xsession.enable = true;
	systemd.user.targets.tray = {
		Unit = {
			Description = "Home Manager System Tray";
			Wants = [ "graphical-session-pre.target" ];
		};
	};

	# FIXME-QA(Krey): This should be a wrapper
	home.packages = [ pkgs.grim ]; # Add the dependency
}
