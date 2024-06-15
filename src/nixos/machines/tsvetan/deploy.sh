#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

set -e # Exit on false return

ragenixDir="/run/agenix"

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "/tmp/ragenix" ] || mkdir /tmp/ragenix

# Get the disks password
[ -f "$ragenixDir/tsvetan-disks-password" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/tsvetan/secrets/tsvetan-disks-password.age" > "/tmp/ragenix/tsvetan-disks-password"
	sudo cp /tmp/ragenix/tsvetan-disks-password "$ragenixDir/tsvetan-disks-password"
}

# Parse the SSH Keys
[ -f "$ragenixDir/tsvetan-ssh-ed25519-private" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/tsvetan/secrets/tsvetan-ssh-ed25519-private.age" > "/tmp/ragenix/tsvetan-ssh-ed25519-private"
	chmod 600 /tmp/ragenix/tsvetan-ssh-ed25519-private
	sudo cp /tmp/ragenix/tsvetan-ssh-ed25519-private "$ragenixDir/tsvetan-ssh-ed25519-private"
}

# Install System
sudo disko-install --flake '.#tsvetan' --disk system /dev/sda \
	--extra-files "$ragenixDir/tsvetan-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
