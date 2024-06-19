{ ... }:

{
	perSystem = { inputs', ... }: {
		mission-control.scripts = {
			"deploy" = {
				description = "Deploy the configuration to all systems or specified";
				category = "Administration";
				exec = ''
					case "$*" in
						"")
							for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
								case "$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")" in
									"OK")
										echo "Deploying the configuration for system: $system"

										${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
											switch \
											--flake "git+file://$FLAKE_ROOT#$system" \
											--target-host "root@$system.systems.nx" \
											--option eval-cache false |& ${inputs'.nixpkgs.legacyPackages.gawk}/bin/awk "{ print \"[$system]\", \$0 }"
									;;
									*) echo "Configuration for system '$system' is not valid, skipping.."
								esac
								sleep 0.5 # Give it some delay
							done
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
