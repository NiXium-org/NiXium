{ pkgs, ... }:

# Task to DEPLOY the derivation on all systems or just specified

{
	deploy-task = pkgs.writeShellScriptBin "deploy-task" ''
		case "$*" in
			"")
				for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
					case "$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")" in
						"OK")
							echo "Deploying the configuration for system: $system"

							${pkgs.nixos-rebuild}/bin/nixos-rebuild \
								switch \
								--flake "git+file://$FLAKE_ROOT#$system" \
								--target-host "root@$system.systems.nx" \
								--option eval-cache false |& ${pkgs.gawk}/bin/awk "{ print \"[$system]\", \$0 }"
						;;
						*) echo "Configuration for system '$system' is not valid, skipping.."
					esac
					sleep 0.5 # Give it some delay
				done
				;;
			*)
				echo "Deploying the configuration for system: $*"

				${pkgs.nixos-rebuild}/bin/nixos-rebuild \
					switch \
					--flake "git+file://$FLAKE_ROOT#$*" \
					--target-host "root@$*.systems.nx" \
					--option eval-cache false
		esac
	'';
}

