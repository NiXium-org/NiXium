# shellcheck shell=sh # POSIX

# FIXME-QA(Krey): Is there less of an eye-sore way to do this?
# shellcheck disable=SC2154 # Variables provided to the environment by Nix
echo "$systemDevice" >/dev/null
echo "$systemDeviceBlock" >/dev/null
echo "$secretPasswordPath" >/dev/null
echo "$secretSSHHostKeyPath" >/dev/null

# # FIXME-QA(Krey): This should be a runtimeInput
# die() { printf "FATAL: %s\n" "$2"; exit ;}

# # FIXME(Krey): Move this into it's own library
# # We have to use `env PATH=$PATH` so that used commands are ensured to use the correct PATH to see the expected binaries
# esudo() { sudo env "PATH=$PATH" "$@" ;}

pwd
exit 23

# # FIXME(Krey): This should be managed for all used scripts
# # Refer to https://github.com/srid/flake-root/discussions/5 for details tldr flake-root doesn't currently allow parsing the specific commit
# [ -n "$FLAKE_ROOT" ] || FLAKE_ROOT="github:NiXium-org/NiXium/$(curl -s -X GET "https://api.github.com/repos/NiXium-org/NiXium/commits" | jq -r '.[0].sha')"

# # Check if the declared installation device is available on the target system, if not fail for safety
# [ -b "$systemDevice" ] || die 1 "Expected device was not found, refusing to install for safety"

# ragenixTempDir="/run/agenix"
# ragenixIdentity="$HOME/.ssh/id_ed25519"

# # Manage Ragenix - The Rust implementation of age for managing secret files
# 	# If the directory is not a symlink already then assume that the deployment is requested on a non-NiXium OS and mimic the file hierarchy
# 	[ -L "$ragenixTempDir" ] || {
# 		[ -d "$ragenixTempDir.d/1" ] || sudo mkdir --parents "$ragenixTempDir.d/1"
# 		sudo ln -s "$ragenixTempDir.d/1" "$ragenixTempDir"

# 		# Ensure correct permission
# 		sudo chown -R root:keys "$ragenixTempDir"
# 		sudo chmod -R 400 "$ragenixTempDir"
# 	}

# 	# The disk password has to be in /run/agenix/ for `disko-install` to not fail
# 	[ -s "$ragenixTempDir/mracek-disks-password" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-disks-password" "$secretPasswordPath"

# 	[ -s "$ragenixTempDir/mracek-ssh-ed25519-private" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-ssh-ed25519-private" "$secretSSHHostKeyPath"

# nixos-rebuild build --flake "$FLAKE_ROOT#nixos-mracek-stable" # pre-build the configuration

# # shellcheck disable=SC2312 # We are expecting to trigger a script failure if the `realpath` fails, apparently fixed in master shellcheck
# esudo disko-install \
# 	--flake "$FLAKE_ROOT#nixos-mracek-stable" \
# 	--mode format \
# 	--debug \
# 	--disk system "$(realpath "$systemDeviceBlock")" \
# 	--extra-files "$ragenixTempDir/mracek-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
