{ pkgs, lib, config, ...}:

# Module which enables The European Identification through web (Web eID) on sourced target system

# Credit: https://github.com/fbegyn/nixos-configuration/blob/8ba0191d2cfa5154b62d835820fb3f7ea44d7446/common/eid.nix#L22

let
	# browser-eid-overlay = import ../overlays/browser-eid.nix;
	inherit (lib) mkIf;
in {
	# nixpkgs.overlays = [
	#   browser-eid-overlay
	# ];

	# NOTE(Krey): Might conflict with smart cards for OpenGPG
	services.pcscd = {
		enable = true;
		plugins = [ pkgs.ccid ]; # NOTE(Krey): No idea why is this needed, asked in https://github.com/fbegyn/nixos-configuration/issues/17
	};

	environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
		module: ${pkgs.opensc}/lib/opensc-pkcs11.so
	'';

	# Firefox
	programs = {
		firefox = mkIf config.programs.firefox.enable {
			nativeMessagingHosts.packages = [ pkgs.web-eid-app ];
			policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
		};
	};


	# Chromium/Chrome
	# FIXME-QA(Krey): This should only be applied for when chromium/chrome is used and with option to not use this
	# environment.etc."chromium/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
	# environment.etc."opt/chrome/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
}
