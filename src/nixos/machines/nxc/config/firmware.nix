{ ... }:

# Firmware management of NXC

{
	# FIXME(Krey): There shouldn't be anything that depends on third party firmware, check post deployment and remove this as needed
	services.fwupd.enable = true; # Use FWUP daemon to keep firmware files up-to-date
}
