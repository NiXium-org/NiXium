{ lib, ... }:

# Configuration of the installer image with GNOME

let
	inherit (lib) mkForce;
in {
	# GNOME
		services.xserver.enable = true;
		services.xserver.displayManager.gdm.enable = true;
		services.xserver.desktopManager.gnome.enable = true;
		networking.wireless.enable = mkForce false; # Conflicting option that is enabled by default

	# SSH
		users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" ]; # Allow root access for all systems to KREYREN
}
