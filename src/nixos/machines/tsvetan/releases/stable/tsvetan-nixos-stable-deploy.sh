# shellcheck shell=sh # POSIX

# shellcheck disable=SC2312 # Upstream bug fixed in master, pending release: https://github.com/koalaman/shellcheck/issues/3042

# shellcheck disable=SC2154 # Variables provided to the environment by Nix
echo "$systemDevice" >/dev/null
echo "$systemDeviceBlock" >/dev/null
echo "$secretTsvetanPasswordPath" >/dev/null
echo "$secretTsvetanKeyPath" >/dev/null

# FIXME-QA(Krey): This should be a runtimeInput
die() { printf "FATAL: %s\n" "$2"; exit ;}

# We have to use `env PATH=$PATH` so that used commands are ensured to use the correct PATH to see the expected binaries
esudo() { sudo env "PATH=$PATH" "$@" ;}

[ -b "$systemDevice" ] || die 1 "Expected device was not found, refusing to install for safety"

ragenixTempDir="/run/agenix"
ragenixIdentity="$HOME/.ssh/id_ed25519"

# Manage Ragenix - The Rust implementation of age for managing secret files
	[ -L "$ragenixTempDir" ] || {
		[ -d "$ragenixTempDir.d/1" ] || sudo mkdir "$ragenixTempDir.d/1"
		ln -s "$ragenixTempDir" "$ragenixTempDir.d/1"
	}
	sudo chown -R "root:keys" "$ragenixTempDir"
	sudo chmod -R 400 "$ragenixTempDir"

	[ -s "$ragenixTempDir/tsvetan-disks-password" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-disks-password" "$secretTsvetanPasswordPath"

	[ -s "$ragenixTempDir/tsvetan-ssh-ed25519-private" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-ssh-ed25519-private" "$secretTsvetanKeyPath"

# For the system to be able to process the runtime it needs 4GB of swap, if it does not have it then create a swap file
	swapFile="/swapfile"
	[ "$(awk '/SwapTotal/ {print $2}' /proc/meminfo)" >= 4194304 ] || {
		swapon -s | grep -q "$swapFile" || esudo swapoff "$swapFile" # Deactivate the swapfile if it's already there so that we can resize it
		[ "$(stat -c%s "$swapFile")" >= 4194304 ] || esudo dd if=/dev/zero of="$swapFile" bs=1M count=4096 conv=notrunc # Resize the swap file to the desired size

		# Ensure correct permissions
		esudo chmod 600 "$swapFile"
		esudo chown root:root

		esudo mkswap "$swapFile" # Make swap
	}

	swapon -s | grep -q "$swapFile" || esudo swapon "$swapFile" # Activate the swapfile if it's not already

nix build '.#nixos-tsvetan-stable' # pre-build the image

esudo disko-install \
	--flake "$FLAKE_ROOT#nixos-tsvetan-stable" \
	--mode format \
	--debug \
	--disk system "$(realpath "$systemDeviceBlock")" \
	--extra-files "$ragenixTempDir/tsvetan-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key

# FIXME(Krey): Flash u-boot, currently blocked by https://github.com/OLIMEX/DIY-LAPTOP/issues/73 (flashing it manually via SPI clamp and ch341a programmer atm)

# FIXME(Krey): Flash firmware for keyboard
# FIXME(Krey): Flash firmware for touchpad
