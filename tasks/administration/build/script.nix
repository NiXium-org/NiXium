{ pkgs, ... }:

# Task to BUILD, but not deploy the derivation of all systems or just specified

{
	build-task = pkgs.writeShellScriptBin "build-task" ''
		case "$*" in
			"all")
				for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
					case "$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")" in
						"OK")
							echo "Building the configuration for system: $system"

							${pkgs.nixos-rebuild}/bin/nixos-rebuild \
								build \
									--flake "git+file://$FLAKE_ROOT#$system" \
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

				${pkgs.nixos-rebuild}/bin/nixos-rebuild \
					build \
						--flake "git+file://$FLAKE_ROOT#$system" \
						--target-host "root@$system.systems.nx" \
						--option eval-cache false
				;;
			*)
				echo "Building configuration for system: $*"

				${pkgs.nixos-rebuild}/bin/nixos-rebuild \
					build \
						--flake "git+file://$FLAKE_ROOT#$*" \
						--target-host "root@$*.systems.nx" \
						--option eval-cache false
		esac
	'';
}

