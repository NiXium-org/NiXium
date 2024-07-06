#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

set -e # Exit on false return

ragenixDir="/run/agenix"

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "/tmp/ragenix" ] || mkdir /tmp/ragenix

# Get the disks password
[ -f "$ragenixDir/mracek-disks-password" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/mracek/secrets/mracek-disks-password.age" > "/tmp/ragenix/mracek-disks-password"
	sudo cp /tmp/ragenix/mracek-disks-password "$ragenixDir/mracek-disks-password"
}

# Parse the SSH Keys
[ -f "$ragenixDir/mracek-ssh-ed25519-private" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/mracek/secrets/mracek-ssh-ed25519-private.age" > "/tmp/ragenix/mracek-ssh-ed25519-private"
	chmod 600 /tmp/ragenix/mracek-ssh-ed25519-private
	sudo cp /tmp/ragenix/mracek-ssh-ed25519-private "$ragenixDir/mracek-ssh-ed25519-private"
}

# Install System
sudo disko-install --flake '.#mracek' --disk system $(realpath /dev/disk/by-id/ata-WDC_WDS500G2B0A-00SM50_21101J456803) \
	--extra-files "$ragenixDir/mracek-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
