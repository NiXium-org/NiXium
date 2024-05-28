{ self, config, lib, ...}:

# Locale Management Module

let
	inherit (lib) mkIf;
in mkIf config.boot.impermanence.enable {
	# Impermanence
	environment.persistence."/nix/persist/system" = {
		hideMounts = true;
		directories = [
			"/var/log" # Logs
			"/var/lib/bluetooth" # Keep bluetooth configs
			"/var/lib/nixos" # Nix stuff
			"/var/lib/systemd/coredump" # Dunno
			"/etc/NetworkManager/system-connections" # WiFi configs

			{ directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }

			# CCache
			(mkIf config.programs.ccache.enable {
				directory = config.programs.ccache.cacheDir;
				user = "root";
				group = "nixbld";
				mode = "u=,g=rwx,o=";
			})
		];
		files = [
			"/etc/machine-id" # Unique ID of the system

			{ file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }

			# SSH Keys
			"/etc/ssh/ssh_host_ed25519_key"
			"/etc/ssh/ssh_host_ed25519_key.pub"
		];
	};
}
