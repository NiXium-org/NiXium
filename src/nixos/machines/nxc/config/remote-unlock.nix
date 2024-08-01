{ ... }:

# Implementation of a remote-unlock for NXC

{
	boot.initrd.network.ssh.enable = true;
	boot.initrd.network.enable = true;

	boot.initrd.network.ssh.authorizedKeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org"; # Authorize the Super Administrator (KREYREN) to access the SSH in initrd

	boot.initrd.includeDefaultModules = true; # Has to be set to true to be able to input decrypting password
}
