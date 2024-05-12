{ config, pkgs, ... }:

# Power management for TUPAC

# DO_NOT_USE(Krey): Requires a Mainboard firmware update

# Credit: https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221

let
	hibernateEnvironment = {
		HIBERNATE_SECONDS = "3600"; # In seconds
		HIBERNATE_LOCK = "/var/run/autohibernate.lock";
	};
in {
	systemd.services."awake-after-suspend-for-a-time" = {
		description = "Sets up the suspend so that it'll wake for hibernation";
		wantedBy = [ "suspend.target" ];
		before = [ "systemd-suspend.service" ];
		environment = hibernateEnvironment;
		script = ''
			curtime="$(date +%s)"
			echo "$curtime $1" >> /tmp/autohibernate.log
			echo "$curtime" > "$HIBERNATE_LOCK"
			${pkgs.utillinux}/bin/rtcwake -m no -s "$HIBERNATE_SECONDS"
		'';
		serviceConfig.Type = "simple";
	};
	systemd.services."hibernate-after-recovery" = {
		description = "Hibernates after a suspend recovery due to timeout";
		wantedBy = [ "suspend.target" ];
		after = [ "systemd-suspend.service" ];
		environment = hibernateEnvironment;
		script = ''
			curtime="$(date +%s)"
			sustime="$(cat $HIBERNATE_LOCK)"
			rm "$HIBERNATE_LOCK"
			if [ "$(($curtime - $sustime))" -ge "$HIBERNATE_SECONDS" ] ; then
				systemctl hibernate
			else
				${pkgs.utillinux}/bin/rtcwake -m no -s 1
			fi
		'';
		serviceConfig.Type = "simple";
	};

	services.logind = {
		lidSwitchExternalPower = "lock"; # Lock the system on closing the lid when on external power
	};
}
