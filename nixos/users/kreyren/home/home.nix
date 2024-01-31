# Impurities to be purified:
## FreeCAD
### Generic
#### Use system proxy
#### Tree View Mode: Both
#### Orbit style: Turntable
#### New Shape Color: Random
### Addons
#### A2Plus
#### Fasteners
#### LCInterlocking
#### Modern-UI
#### Alternate OpenSCAD Importer
#### WebTools
### Theme
#### ExtremeProDark
## FreeTube
### Settings
#### General Settings
##### Preferred API Backend: Local API
#### Theme Settings
##### Base Theme: Dracula
##### Main Color Theme: Indigo
#### Proxy Settings
##### Enable Tor/Proxy: TRUE
##### Proxy Host: 127.0.0.1
##### Proxy Port Number: 9050 (Tor)
#### External Player Settings
##### External Player: mpv
##### Custom External Player Executable: /home/raptor/.nix-profile/bin/torsocks
##### Custom External Player Arguments: /home/raptor/.nix-profile/bin/mpv;--ytdl-format=bestvideo[height=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best
#### SponsorBlock Settings
##### Enable SponsorBlock: TRUE

{ config, pkgs, ... }:

# Common Home-Manager configuration across all systems

{
	home.username = "raptor";
	home.homeDirectory = ("/home/" + config.home.username);

	# Global Packages Installed On ALL Systems
	home.packages = [
		pkgs.keepassxc
		pkgs.xorg.xkill
		pkgs.htop
		pkgs.wget
		pkgs.wcalc
		pkgs.ripgrep
		pkgs.pciutils # for lspci
		pkgs.file
		pkgs.tree

		pkgs.cryptsetup

		pkgs.xclip
		pkgs.flameshot
		pkgs.mpv
		pkgs.torsocks

		pkgs.ix
	];
}
