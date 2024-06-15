{ lib, config, ... }:

let
	inherit (lib) mkIf;
in {
	# FIXME-QA(Krey): Should only be used for home-manager NixOS Module, not expected to work in standalone setup!
	home.persistence."/nix/persist/users/kreyren" = mkIf config.home.impermanence.enable {
		directories = [
			"Downloads"
			"Music"
			"Pictures"
			"Documents"
			"Videos"
			".gnupg"
			".ssh"
			".config/Element" # Element-Desktop
			".local/share/keyrings"
			".local/share/direnv"
			".local/share/fractal"
			".local/state/nix/profiles"
			# FIXME-QA(Krey): Should only be on selected systems
			".local/share/anime-game-launcher"
		];
		files = [
			".config/monitors.xml"
		];
		allowOther = true;
	};
}
