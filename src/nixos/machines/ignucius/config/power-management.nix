{ config, pkgs, lib, ... }:

#! # Power Management of IGNUCIUS
#!
#! Test Script:
#!     $ echo "$(($(cat /sys/class/power_supply/BAT0/voltage_now) / 1000000 * $(cat /sys/class/power_supply/BAT0/current_now) / 1000000))"
#!
#! Credit:
#! * https://gist.github.com/polamjag/a76f34a4991b35f9434a

# This doesn't seem to change anything?
			# * https://forums.gentoo.org/viewtopic-t-1068292-start-0.html

let
	inherit (lib) mkIf mkMerge;
in mkMerge [
	# TLP Management
	(mkIf (config.services.tlp.enable == true) {
		services.tlp.settings = {
			TLP_ENABLE = 1; # Use TLP

			# Set Governors depending on power input
			CPU_SCALING_GOVERNOR_ON_AC = "performance"; # AC power
			# FIXME(Krey): Powersave is not available as a governor?
			CPU_SCALING_GOVERNOR_ON_BAT = "schedutil"; # BATTERY power

			# Whether to use boost depending on power input
			CPU_BOOST_ON_AC = 1;
			CPU_BOOST_ON_BAT = 0;

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
		# Required for interaction between the solutions
			boot.kernelModules = [ "acpi_call" ];
			boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
	}
]
