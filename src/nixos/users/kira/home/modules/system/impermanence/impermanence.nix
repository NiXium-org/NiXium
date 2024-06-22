{ lib, config, ... }:

let
	inherit (lib) mkIf;
in {
	# FIXME-QA(Krey): Should only be used for home-manager NixOS Module, not expected to work in standalone setup!
	home.persistence."/nix/persist/users/kira" = mkIf config.home.impermanence.enable {
		directories = [
			"Documents"
			"Downloads"
			"Monero" # For Monero Wallet
			"Music"
			"Pictures"
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
			# FIXME-QA(Krey): This should be generated for each system
			".config/monitors.xml"
		];
		allowOther = true;
	};
}
