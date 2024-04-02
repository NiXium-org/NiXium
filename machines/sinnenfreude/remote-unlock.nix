{ config, ... }:

# Configures remote-unlock for SINNENFREUDE

# Inspired-by: https://github.com/cole-h/nixos-config/blob/95ae2f67331fbe59020cf50f9063c7d234b5b5d9/hosts/nixos/scadrial/modules/boot/remote-unlock.nix

{
	# Enable networking during initrd
		boot.initrd.systemd.network.enable = config.boot.initrd.systemd.enable; # systemd-initrd
		boot.initrd.enable = config.boot.initrd.systemd.enable; # regular initrd

	boot.initrd.systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent"; # ???

	boot.initrd.network.ssh.enable = true; # Enable SSH during initrd
		boot.initrd.network.ssh.hostKeys = [ "/nix/persist/ssh_initrd_ed25519_key" ];

	boot.initrd.secrets = {
		"/etc/secrets/initrd/ssh_host_ed25519_key" = /nix/persist/ssh_initrd_ed25519_key;
	};
}
