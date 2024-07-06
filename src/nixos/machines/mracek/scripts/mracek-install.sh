#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

system="${1:-"mracek"}"
disk="${2:-"$(realpath /dev/disk/by-id/ata-WDC_WDS500G2B0A-00SM50_21101J456803)"}"

ragenixDir="/run/agenix" # Directory used to store secrets
ragenixTempDir="/var/tmp/ragenix" # Directory used to work with secrets
ragenixIdentity="${ragenixIdentity:-"$HOME/.ssh/id_ed25519"}" # Location of the identity file used to work with secrets

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "$ragenixTempDir" ] || mkdir "$ragenixTempDir"

# Ensure that we can write in the directory
sudo chown --recursive "$USER:root" "$ragenixTempDir" # Set Ownership
sudo chmod --recursive 660 "$ragenixTempDir" # Set Permissions

# FIXME-QA(Krey): This should be part of 'mission-control'
die() { printf "FATAL: %s\n" "$2"; exit 1 ;}

decryptSecret() {
	secretFile="$1" # e.g. tupac-disks-password

	[ -f "$ragenixDir/$secretFile" ] || {
		age \
			--identity "$ragenixIdentity" \
			--decrypt \
			--output "$ragenixTempDir/$secretFile" \
			"$FLAKE_ROOT/src/nixos/machines/$system/secrets/$secretFile"

		sudo cp "$ragenixTempDir/$secretFile" "$ragenixDir/$secretFile"
	}
}

# Declared this way in case some system needs a special treatment
case "$system" in
	*)
		echo "Installing configuration for system '$system' on disk '$disk'"

		# Decrypt needed secrets
		# DNM(Krey): To be managed for flake environment..
		decryptSecret "$system-disks-password"
		decryptSecret "$system-ssh-ed25519-private"

		# mracek-disks-password
		# age \
		# 	--identity "$ragenixIdentity" \
		# 	--decrypt \
		# 	--output "$ragenixTempDir/$secretFile" \
		# 	"$FLAKE_ROOT/src/nixos/machines/$system/secrets/$secretFile"

		# Perform the installation
		sudo disko-install \
			--dry-run \
			--flake "git+file://$FLAKE_ROOT#$system" \
			--disk system "$disk" \
			--extra-files \
				"$ragenixDir/$system-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
esac
