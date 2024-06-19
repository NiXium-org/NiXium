{ ... }:

{
	perSystem = { inputs', pkgs, lib, ... }: {
		mission-control.scripts = {
			"switch" = {
				description = "Switch the configuration on the current supported system or specified";
				category = "Administration";
				exec = ''
					case "$*" in
						"")
							hostname="$(hostname --short)"
							echo "Switching configuration for system: $hostname"

							${inputs'.nixpkgs.legacyPackages.openssh}/bin/ssh root@localhost \
								${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
									switch \
										--flake "git+file://$FLAKE_ROOT#$hostname" \
										--option eval-cache false
							;;
						*)
							echo "Switching configuration for system: $*"

							${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
								switch \
									--flake "git+file://$FLAKE_ROOT#$*" \
									--target-host "root@$*.systems.nx" \
									--option eval-cache false
					esac
				'';
			};
		};
	};
}
