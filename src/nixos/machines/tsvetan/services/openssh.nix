{ self, config, lib, ... }:

# TSVETAN-specific configuration of OpenSSH

let
	inherit (lib) mkIf mkForce;
in mkIf config.services.openssh.enable {
	# Import the private key for an onion service
	# age.secrets.tsvetan-onion-openssh-private = {
	# 	file = ../secrets/tsvetan-onion-openssh-private.age;

	# 	owner = "tor";
	# 	group = "tor";

	# 	path = "/var/lib/tor/onion/openssh/hs_ed25519_secret_key";

	# 	symlink = false; # Appears to not work as symlink
	# };

	services.tor.relay.onionServices."openssh" = {
		map = mkIf config.services.tor.enable config.services.openssh.ports; # Provide hidden SSH
		# secretKey = "/run/keys/tor/onion/openssh/hs_ed25519_secret_key";
	};

	# Set the pubkey
	environment.etc."ssh/ssh_host_ed25519_key.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdqMVQ3TO5ckmk9nepAY/7zLHy555EkzBJxpfTIwuT5 root@tsvetan";

	services.openssh.hostKeys = mkForce []; # Do not generate SSH keys
}
