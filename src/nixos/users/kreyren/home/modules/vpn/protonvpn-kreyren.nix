{ pkgs, lib, config, ... }:

let
	inherit (lib) mkIf;
in {
	age.secrets.kreyren-wireproxy-protonvpn-config.file = ./kreyren-wireproxy-protonvpn-config.age;

	# FIXME(Krey): Make an option for this
	systemd.user.services.wireproxy-protonvpn = {
		Unit = {
			Description = "wireproxy protonvpn initialization";
			After = [ "agenix.service" ];
		};
		Service = {
			Type = "exec";
			ExecStart = "${pkgs.wireproxy}/bin/wireproxy --config /run/user/1000/agenix/kreyren-wireproxy-protonvpn-config";
			Restart = "on-failure";
		};
		Install.WantedBy = [ "default.target" ];
	};
}
