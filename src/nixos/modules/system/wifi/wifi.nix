{ self, config, lib, ... }:

# Time Management Module

let
	inherit (lib) mkIf mkDefault;
in mkIf config.networking.networkmanager.enable {
	age.secrets.home-wifi-psk = {
		file = ./homeBaseKreyren-WiFi-PSK.age;
		path = "/etc/NetworkManager/system-connections/homeBaseKreyren.nmconnection";
	};
}
