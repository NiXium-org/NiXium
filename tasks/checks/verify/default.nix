{ ... }:

{
	perSystem = { inputs', ... }: {
		mission-control.scripts = {
			verify = {
				description = "Verify the declaration of all systems or specified";
				category = "Checks";
				exec = ''
					case "$*" in
						"all") # Verify All Systems
							for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
								status=$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")
								case "$status" in
									"OK")
										echo "Checking system: $system"

										${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
											dry-build \
											--flake "git+file://$FLAKE_ROOT#$system" \
											--option eval-cache false \
											--show-trace || echo "WARNING: System '$system' failed evaluation!"
									;;
									"WIP") echo "Configuration for system '$system' is marked a Work-in-Progress, skipping build.." ;;
									*) echo "System '$system' reports undeclared status state: $status"
								esac
							done
						;;
						"") # Verify Current System
							hostname="$(hostname --short)"
							echo "Checking system: $hostname"
							${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild dry-build \
								--flake "git+file://$FLAKE_ROOT#$hostname" \
								--option eval-cache false \
								--show-trace
						;;
						*) # Verify System By (derivation) Name
							echo "Checking system: $*"
							${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild dry-build \
							--flake "git+file://$FLAKE_ROOT#$*" \
							--option eval-cache false \
							--show-trace
					esac
				'';
			};
		};
	};
}
