# shellcheck shell=sh # POSIX

# shellcheck disable=SC2154 # Variables provided to the environment by Nix
echo "$systemDevice" >/dev/null
echo "$systemDeviceBlock" >/dev/null
echo "$secretTsvetanPasswordPath" >/dev/null
echo "$secretTsvetanKeyPath" >/dev/null

targetSystem="root@192.168.0.62"

# FIXME-QA(Krey): This should be a runtimeInput
die() { printf "FATAL: %s\n" "$2"; exit ;}

# We have to use `env PATH=$PATH` so that used commands are ensured to use the correct PATH to see the expected binaries
esudo() { sudo env "PATH=$PATH" "$@" ;}

# [ -b "$systemDevice" ] || die 1 "Expected device was not found, refusing to install for safety"

ragenixTempDir="/run/agenix"
ragenixIdentity="$HOME/.ssh/id_ed25519"

# Manage Ragenix - The Rust implementation of age for managing secret files
	# If the directory is not a symlink already then assume that the deployment is requested on a non-NiXium OS and mimic the file hierarchy
	[ -L "$ragenixTempDir" ] || {
		[ -d "$ragenixTempDir.d/1" ] || sudo mkdir "$ragenixTempDir.d/1"
		ln -s "$ragenixTempDir" "$ragenixTempDir.d/1"

		# Ensure correct permission
		sudo chown -R "root:keys" "$ragenixTempDir"
		sudo chmod -R 400 "$ragenixTempDir"
	}

	[ -s "$ragenixTempDir/tsvetan-disks-password" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-disks-password" "$secretTsvetanPasswordPath"

	[ -s "$ragenixTempDir/tsvetan-ssh-ed25519-private" ] || esudo age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-ssh-ed25519-private" "$secretTsvetanKeyPath"

# For the system to be able to process the runtime it needs 4GB of swap, if it does not have it then create a swap file
	swapFile="/swapfile"
	# shellcheck disable=SC2312 # Upstream bug, should not output with the `|| echo 0` used as the de-factor '|| true' recommended
	[ "$(awk '/SwapTotal/ {print $2}' /proc/meminfo || echo 0)" -ge 4194304 ] || {
		swapon -s | grep -q "$swapFile" || esudo swapoff "$swapFile" # Deactivate the swapfile if it's already there so that we can resize it
		[ "$(stat -c%s "$swapFile" || echo 0)" -lt 4194304 ] || esudo dd if=/dev/zero of="$swapFile" bs=1M count=4096 conv=notrunc # Resize the swap file to the desired size

		# Ensure correct permissions
		esudo chmod 600 "$swapFile"
		esudo chown root:root

		esudo mkswap "$swapFile" # Make swap
	}

	# Swap file exists, is at expected size, but not activated
	swapon -s | grep -q "$swapFile" || {
		# shellcheck disable=SC2312 # Upstream bug, should not output with the `|| echo 0` used as the de-factor '|| true' recommended
		[ "$(stat -c%s "$swapFile" || echo 0)" -lt 4194304 ] || esudo swapon "$swapFile"
	}

nixos-rebuild build --flake "$FLAKE_ROOT#nixos-tsvetan-unstable" # pre-build the configuration



esudo nixos-anywhere \
	--flake "$FLAKE_ROOT#nixos-tsvetan-unstable" \
	-i "$ragenixIdentity" \
	--debug \
	"$targetSystem"

# FIXME(Krey): Flash u-boot, currently blocked by https://github.com/OLIMEX/DIY-LAPTOP/issues/73 (flashing it manually via SPI clamp and ch341a programmer atm)

# FIXME(Krey): Flash firmware for keyboard
# FIXME(Krey): Flash firmware for touchpad
