#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

# Invokation: PATH_TO_THIS_REPO $ nix-shell -p zfs --run ./src/nixos/machines/cookie/deploy.sh

export LC_ALL=C

set -e # Exit on false return

ragenixDir="/run/agenix"

[ -d "$ragenixDir" ] || sudo mkdir "$ragenixDir"
[ -d "/tmp/ragenix" ] || mkdir /tmp/ragenix

# Get the disks password
[ -f "$ragenixDir/cookie-disks-password" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/cookie/secrets/cookie-disks-password.age" > "/tmp/ragenix/cookie-disks-password"
	sudo cp /tmp/ragenix/cookie-disks-password "$ragenixDir/cookie-disks-password"
}

# Parse the SSH Keys
[ -f "$ragenixDir/cookie-ssh-ed25519-private" ] || {
	age --decrypt -i "$HOME/.ssh/id_ed25519" --decrypt "./src/nixos/machines/cookie/secrets/cookie-ssh-ed25519-private.age" > "/tmp/ragenix/cookie-ssh-ed25519-private"
	chmod 600 /tmp/ragenix/cookie-ssh-ed25519-private
	sudo cp /tmp/ragenix/cookie-ssh-ed25519-private "$ragenixDir/cookie-ssh-ed25519-private"
}

# Install System
# TODO(Krey->Tanvir): Decide on which drive you want to install NiXium
sudo disko-install --flake '.#cookie' --disk system "$(realpath /dev/disk/by-id/ADD_ME)" \
	--extra-files "$ragenixDir/cookie-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key |& tee ./src/nixos/machines/cookie/disko-install.log
