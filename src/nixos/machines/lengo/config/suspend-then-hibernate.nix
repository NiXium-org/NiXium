{ config, pkgs, ... }:

# Module that implements suspend-then-hibernate for LENGO

let
	hibernateSeconds = "60";
in {
	services.logind = {
		powerKey = "suspend-then-hibernate"; # Standard power off
		powerKeyLongPress = "poweroff"; # PowerOff
		# Hibernate if not connected to the battery and unused for hibernateSeconds
		lidSwitch = "suspend-then-hibernate";
		# Only suspend if on external power to speed up charging
		lidSwitchExternalPower = "suspend";
	};

	systemd.sleep.extraConfig = "HibernateDelaySec=${hibernateSeconds}";
}