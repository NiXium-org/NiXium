{ config, pkgs, lib, ... }:

#! # Power Management of LENGO
#!
#! Test Script:
#!     $ echo "$(($(cat /sys/class/power_supply/BAT0/voltage_now) / 1000000 * $(cat /sys/class/power_supply/BAT0/current_now) / 1000000))"
#!
#! Credit:
#! * https://gist.github.com/polamjag/a76f34a4991b35f9434a

# This doesn't seem to change anything?
			# * https://forums.gentoo.org/viewtopic-t-1068292-start-0.html

# Refer to https://linrunner.de/tlp/settings for configuration reference

# FIXME(Krey->Kira): This needs adjustments to work on Legion Go reliably for it's specific usecase which is difficult to be done by me as I can't test the device this long.

let
	inherit (lib) mkIf mkMerge;
in mkIf config.powerManagement.enable (mkMerge [
	# TLP Management
	(mkIf (config.services.tlp.enable == true) {
		services.tlp.settings = {
			TLP_ENABLE = 1; # Use TLP

			# Platform Profiles
			PLATFORM_PROFILE_ON_AC = "performance";
			PLATFORM_PROFILE_ON_BAT = "balanced";

			# Set Governors depending on power input
				# [root@lengo:~]# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
				# performance powersave
			CPU_SCALING_GOVERNOR_ON_AC = "performance"; # AC power
			CPU_SCALING_GOVERNOR_ON_BAT = "balance_power"; # BATTERY power

			# Whether to use boost depending on power input
			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0; # Do Not Boost on BAT Power

			# Energy Profile Policy
			CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
			CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

			# CPU Performance Scaling
			CPU_MAX_PERF_ON_AC = 100;
			CPU_MIN_PERF_ON_AC = 0;

			CPU_MAX_PERF_ON_BAT = 10;
			CPU_MIN_PERF_ON_BAT = 0;

			# CPU Scaling
			CPU_SCALING_MAX_FREQ_ON_AC = 3300000;
			CPU_SCALING_MIN_FREQ_ON_AC = 1200000;

			CPU_SCALING_MAX_FREQ_ON_BAT = 2600000;
			CPU_SCALING_MIN_FREQ_ON_BAT = 1200000;

			# SATA aggressive link power management (ALPM):
			# min_power/medium_power/max_performance
			SATA_LINKPWR_ON_AC = "max_performance";
			SATA_LINKPWR_ON_BAT	=	"min_power";

			# PCI Express Active State Power Management (PCIe ASPM):
			# default/performance/powersave
			# Hint: needs kernel boot option pcie_aspm=force on some machines
			PCIE_ASPM_ON_AC = "performance";
			PCIE_ASPM_ON_BAT = "powersave";

			# WiFi power saving mode: 1=disable/5=enable
			# (Linux 2.6.32 and later, some adapters only!)
			WIFI_PWR_ON_AC = 1;
			WIFI_PWR_ON_BAT = 5;

			# Runtime Power Management for pci(e) bus devices
			# (Kernel >= 2.6.35 only): on=disable/auto=enable
			RUNTIME_PM_ON_AC = "on";
			RUNTIME_PM_ON_BAT = "auto";
		};
	})

	{

	}
])