{ ... }:

{
	perSystem = { inputs', pkgs, lib, ... }: {
		mission-control.scripts = {
			"build" = {
				description = "Build and cache the system configuration without deployment";
				category = "Administration";
				exec = ''
					case "$*" in
						"all")
							for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
								case "$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")" in
									"OK")
										echo "Building the configuration for system: $system"

										${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
											build \
												--flake "$FLAKE_ROOT#$system" \
												--target-host "root@$system.systems.nx" \
												--option eval-cache false
									;;
									*) echo "Configuration for system '$system' is not valid, skipping.."
								esac
							done
							;;
						"")
							system="$(hostname --short)"
							echo "Building the configuration for system: $system"

							${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
								build \
									--flake "$FLAKE_ROOT#$system" \
									--target-host "root@$system.systems.nx" \
									--option eval-cache false
							;;
						*)
							echo "Switching configuration for system: $*"

							${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
								build \
									--flake "$FLAKE_ROOT#$*" \
									--target-host "root@$*.systems.nx" \
									--option eval-cache false
					esac
				'';
			};
		};
	};
}
