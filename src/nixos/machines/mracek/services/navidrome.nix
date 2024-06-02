{ self, config, lib, ... }:

# Mracek-specific configuration of Navidrome

# $ nix-shell -p yt-dlp --run 'yt-dlp --proxy "" -f bestaudio --extract-audio --audio-format opus --audio-quality 256K --output "%(title)s.%(ext)s" --add-metadata --embed-thumbnail URL'

let
	inherit (lib) mkIf;
in mkIf config.services.navidrome.enable {
	# NOTE(Krey): Temporary to figure out the storage and music management
	services.navidrome.settings.MusicFolder = "/nix/persist/system/navidrome-temp";

	services.tor.relay.onionServices."hiddenNavidrome".map = mkIf config.services.tor.enable [{ port = 80; target = { port = config.services.navidrome.settings.Port; }; }];
}
