{ pkgs, config, ... }:

{
	age.secrets.kreyren-wireproxy-protonvpn-config = {
		file = ./kreyren-wireproxy-protonvpn-config.age;
		symlink = false;
	};

	# FIXME(Krey): Make an option for this
	systemd.user.services.wireproxy-protonvpn = {
		Unit = {
			Description = "wireproxy protonvpn initialization";
			After = [ "agenix.service" ];
		};
		Service = {
			Type = "exec";
			ExecStart = "${pkgs.wireproxy}/bin/wireproxy --config ${config.age.secrets.kreyren-wireproxy-protonvpn-config.path}";
			Restart = "on-failure";
		};
		Install.WantedBy = [ "default.target" ];
	};
}
