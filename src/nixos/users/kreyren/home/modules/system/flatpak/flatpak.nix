{ pkgs, lib, nixosConfig, ... }:

let
	inherit (lib) mkIf;
in {
	systemd.user.services.flathub-init = mkIf nixosConfig.services.flatpak.enable {
		Unit = { Description = "flathub initialization"; };
		Service = {
			Type = "exec";
			ExecStart = "${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo";
			Restart = "on-failure";
		};
		Install = { WantedBy = [ "default.target" ]; };
	};
}
