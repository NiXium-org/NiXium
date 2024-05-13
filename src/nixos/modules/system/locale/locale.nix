{ self, lib, ...}:

# Locale Management Module

let
	inherit (lib) mkDefault;
in {
	i18n.defaultLocale = mkDefault "en_US.UTF-8";

	i18n.extraLocaleSettings = mkDefault {
		LANGUAGE = "en_US.UTF-8";
		LC_ALL = "en_US.UTF-8";
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	i18n.supportedLocales = mkDefault [
		"en_US.UTF-8/UTF-8"
	];
}