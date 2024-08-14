{ ... }:

# Firmware management of TSVETAN

{
	services.fwupd.enable = true; # Use FWUP daemon to keep firmware files up-to-date

	# FIXME(Krey): The BLE/WiFi module used doesn't work without proprietary blobs on NixOS -> Implement open-source
	hardware.enableRedistributableFirmware = true;
}
