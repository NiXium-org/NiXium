{ pkgs, ... }:

# Task to INSTALL the specified derivation on current system including the firmware in a fully declarative way

# Refer to https://github.com/nix-community/disko/issues/657#issuecomment-2146978563 for implementation notes

{
	perSystem = { system, inputs, ... }: {
		install-task = pkgs.writeShellScriptBin "install-task" ''
			system="$1"
			disk="$2"

			[ -n "$AGE" ] || AGE="${pkgs.age}/bin/age"
			[ -n "$DISKO_INSTALL" ] || DISKO_INSTALL="${inputs.disko.packages.${system}.disko-install}/bin/disko-install"

			ragenixDir="/run/agenix" # Directory used to store secrets
			ragenixTempDir="/var/tmp/ragenix" # Directory used to work with secrets
			[ -n "$ragenixIdentity" ] ||ragenixIdentity="$HOME/.ssh/id_ed25519" # Location of the identity file used to work with secrets

			[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
			[ -d "$ragenixTempDir" ] || mkdir "$ragenixTempDir"

			# Ensure that we can write in the directory
			sudo chown --recursive "$USER:root" "$ragenixTempDir" # Set Ownership
			sudo chmod --recursive 660 "$ragenixTempDir" # Set Permissions

			# FIXME-QA(Krey): This should be part of 'mission-control'
			die() { printf "FATAL: %s\n" "$2"; exit 1 ;}

			decrypt-secret() {
				secretFile="$1" # e.g. tupac-disks-password

				[ -f "$ragenixDir/$secretFile" ] || {
					$AGE \
						--decrypt \
						--identity "$HOME/.ssh/id_ed25519" \
						--decrypt "$FLAKE_ROOT/src/nixos/machines/$system/secrets/$secretFile" > "$ragenixTempDir/$secretFile"

					sudo cp "$ragenixTempDir/$secretFile" "$ragenixDir/$secretFile"

					# Sanity Checks
					[ -s "$ragenixDir/$secretFile" ] || die 1 "The decryption of secret '$secretFile' resulted in an empty file! Exitting for safety.."
				}
			}

			# Declared this way in case some system needs a special treatment
			case "$system" in
				*)
					echo "Installing configuration for system '$system' on disk '$disk'"

					# Decrypt needed secrets
					decrypt-secret "$system-disks-password"
					decrypt-secret "$system-ssh-ed25519-private"

					# Perform the installation
					sudo $DISKO_INSTALL \
						--flake "git+file://$FLAKE_ROOT#$system" \
						--disk system "$disk"
						--extra-files \
							"$ragenixDir/$system-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
			esac
		'';
	};
}

