#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

set -e # Exit on false return

ragenixDir="/run/agenix"

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "/tmp/ragenix" ] || mkdir /tmp/ragenix

# Get the disks password
[ -f "$ragenixDir/sinnenfreude-disks-password" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/sinnenfreude/secrets/sinnenfreude-disks-password.age" > "/tmp/ragenix/sinnenfreude-disks-password"
	sudo cp /tmp/ragenix/sinnenfreude-disks-password "$ragenixDir/sinnenfreude-disks-password"
}

# Parse the SSH Keys
[ -f "$ragenixDir/sinnenfreude-ssh-ed25519-private" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/sinnenfreude/secrets/sinnenfreude-ssh-ed25519-private.age" > "/tmp/ragenix/sinnenfreude-ssh-ed25519-private"
	chmod 600 /tmp/ragenix/sinnenfreude-ssh-ed25519-private
	sudo cp /tmp/ragenix/sinnenfreude-ssh-ed25519-private "$ragenixDir/sinnenfreude-ssh-ed25519-private"
}

# Install System
sudo disko-install --flake '.#sinnenfreude' --disk system /dev/sda \
	--extra-files "$ragenixDir/sinnenfreude-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
