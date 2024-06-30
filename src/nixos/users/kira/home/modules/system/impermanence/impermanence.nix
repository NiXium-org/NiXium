{ lib, config, ... }:

let
	inherit (lib) mkIf;
in {
	# FIXME-QA(Krey): Should only be used for home-manager NixOS Module, not expected to work in standalone setup!
	home.persistence."/nix/persist/users/kira" = mkIf config.home.impermanence.enable {
		directories = [
			"Desktop"
			"Documents"
			"Downloads"
			"Music"
			"Pictures"
			"Public"
			"Templates"
			"Videos"
			".gnupg"
			".local/state/nix/profiles"
			".ssh"
			".cache"

			# NOTE(Krey): Temporary management until we get Storage Server with declarative sync
			".local/db"
			".config/Nextcloud"

			# FIXME-QA(Krey): This should be applied only when simplex is installed
			".local/share/simplex"

			# FIXME-QA(Krey): Should only be applied if `monero-gui` package is installed
			"Monero"

			# FIXME-QA(Krey): Should only be applied if `element-desktop` is installed
			".config/Element" # Element-Desktop

			# FIXME-QA(Krey): Should only be applied if gnome keyring is used
			".local/share/keyrings"

			# FIXME-QA(Krey): Should only be applied if direnv is used
			".local/share/direnv"

			# FIXME-QA(Krey): Should only be applied if fractal is installed
			".local/share/fractal"

			# FIXME-QA(Krey): Should only be applied if flatpak is installed
			".local/share/flatpak"

			# FIXME-QA(Krey): Should only be applied if `anime-game-launcher` is installed
			".local/share/anime-game-launcher"

			# FIXME-QA(Krey): Should only be applied if `streamio` is installed
			".stremio-server/stremio-cache"
		];
		files = [
			# FIXME-QA(Krey): This should be generated for each system
			".config/monitors.xml"
		];
		allowOther = true;
	};
}