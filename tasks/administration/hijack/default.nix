{ ... }:

# The HIJACK Task

{
	perSystem = { pkgs, ... }: {
		mission-control.scripts = {
			"hijack" = {
				description = "Utilize kexec() to hijack the target system into NiXium";
				category = "Administration";

				exec = pkgs.writeShellApplication {
					name = "tasks-hijack";

					runtimeInputs = [
						pkgs.nixos-install-tools
						pkgs.nixos-rebuild
						pkgs.gnused
						pkgs.git
					];

					# FIXME(Krey): This should use flake-root to set absolute path
					text = builtins.readFile ./tasks-hijack.sh;
				};
			};
		};
	};
}
