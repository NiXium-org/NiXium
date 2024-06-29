#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

# Invokation: PATH_TO_THIS_REPO $ nix-shell -p zfs --run ./src/nixos/machines/tupac/deploy.sh

export LC_ALL=C

set -e # Exit on false return

ragenixDir="/run/agenix"

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "/tmp/ragenix" ] || mkdir /tmp/ragenix

# Get the disks password
[ -f "$ragenixDir/tupac-disks-password" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/tupac/secrets/tupac-disks-password.age" > "/tmp/ragenix/tupac-disks-password"
	sudo cp /tmp/ragenix/tupac-disks-password "$ragenixDir/tupac-disks-password"
}

# Parse the SSH Keys
[ -f "$ragenixDir/tupac-ssh-ed25519-private" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/tupac/secrets/tupac-ssh-ed25519-private.age" > "/tmp/ragenix/tupac-ssh-ed25519-private"
	chmod 600 /tmp/ragenix/tupac-ssh-ed25519-private
	sudo cp /tmp/ragenix/tupac-ssh-ed25519-private "$ragenixDir/tupac-ssh-ed25519-private"
}

# Install System
sudo disko-install --flake '.#tupac' --disk system "$(realpath /dev/disk/by-id/nvme-SOLIDIGM_SSDPFKNU010TZ_BTEH24220RNQ1P0B)" \
	--extra-files "$ragenixDir/tupac-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key |& tee ./src/nixos/machines/tupac/disko-install.log
