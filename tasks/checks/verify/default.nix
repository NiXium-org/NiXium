{ ... }:

{
	perSystem = { inputs', ... }: {
		mission-control.scripts = {
			verify = {
				description = "Verify the declaration of all systems or specified";
				category = "Checks";
				exec = ''
					case "$*" in
						all) # Verify All Systems
							for system in $(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' '); do
								echo "Checking system: $system"

								if [ ! -f "$FLAKE_ROOT/src/nixos/machines/$system/default.nix" ]; then
									${inputs'.nixpkgs.legacyPackages.nixos-rebuild}/bin/nixos-rebuild \
										dry-build \
										--flake "git+file://$FLAKE_ROOT#$system" \
										--option eval-cache false \
										--show-trace || echo "WARNING: System '$system' failed evaluation!"
								else
									echo "The configuration of system '$system' not yet declared, skipping.."
								fi
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
