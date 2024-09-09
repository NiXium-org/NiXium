# shellcheck shell=sh # POSIX

# FIXME-QA(Krey): Is there less of an eye-sore way to do this?
# shellcheck disable=SC2154 # Variables provided to the environment by Nix
echo "$systemDevice" >/dev/null
echo "$systemDeviceBlock" >/dev/null
echo "$secretPasswordPath" >/dev/null
echo "$secretSSHHostKeyPath" >/dev/null

# FIXME-QA(Krey): This should be a runtimeInput
die() { printf "FATAL: %s\n" "$2"; exit ;}

# FIXME(Krey): Move this into it's own runtimeInput
# We have to use `env PATH=$PATH` so that used commands are ensured to use the correct PATH to see the expected binaries
esudo() { sudo env "PATH=$PATH" "$@" ;}

# FIXME(Krey): This should be managed for all used scripts e.g. runtimeEnv
# Refer to https://github.com/srid/flake-root/discussions/5 for details tldr flake-root doesn't currently allow parsing the specific commit
[ -n "$FLAKE_ROOT" ] || FLAKE_ROOT="github:NiXium-org/NiXium/$(curl -s -X GET "https://api.github.com/repos/NiXium-org/NiXium/commits" | jq -r '.[0].sha')"

# Check if the declared installation device is available on the target system, if not fail for safety
[ -b "$systemDevice" ] || die 1 "Expected device was not found, refusing to install for safety"

[ -n "$ragenixTempDir" ] || ragenixTempDir="${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}/nixium"
[ -n "$ragenixIdentity" ] || ragenixIdentity="$HOME/.ssh/id_ed25519"

[ -d "$ragenixTempDir" ] || mkdir "$ragenixTempDir" # Make directory for managing secrets
esudo chown "$USER:users" "$ragenixTempDir" # Ensure expected ownership
esudo chmod 700 "$ragenixTempDir" # Ensure expected permission

# The disk password has to be in /run/agenix/ for `disko-install` to not fail
[ -s "$ragenixTempDir/tupac-disks-password" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tupac-disks-password" "$secretPasswordPath"

[ -s "$ragenixTempDir/tupac-ssh-ed25519-private" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tupac-ssh-ed25519-private" "$secretSSHHostKeyPath"

nixos-rebuild build --flake "$FLAKE_ROOT#nixos-tupac-master" # pre-build the configuration

esudo disko-install \
	--flake "$FLAKE_ROOT#nixos-tupac-master" \
	--mode format \
	--debug \
	--disk system "$(realpath "$systemDeviceBlock")" \
	--extra-files "$ragenixTempDir/tupac-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
