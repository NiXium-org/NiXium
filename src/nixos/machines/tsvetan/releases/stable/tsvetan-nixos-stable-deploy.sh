# FIXME(Krey): Make a swap file of 4 GB as that is needed to deploy the image even with max-jobs set to 0

# FIXME-QA(Krey): This should be a runtimeInput
die() { printf "FATAL: %s\n" "$2"; exit ;}

[ -b "$systemDevice" ] || die 1 "Expected device was not found, refusing to install for safety"

ragenixTempDir="/run/agenix"
ragenixIdentity="$HOME/.ssh/id_ed25519"

[ -L "$ragenixTempDir" ] || {
	[ -d "$ragenixTempDir.d/1" ] || sudo mkdir "$ragenixTempDir.d/1"
	ln -s "$ragenixTempDir" "$ragenixTempDir.d/1"
}
sudo chown -R "root:keys" "$ragenixTempDir"
sudo chmod -R 400 "$ragenixTempDir"

[ -s "$ragenixTempDir/tsvetan-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-disks-password" "$secretTsvetanPasswordPath"

[ -s "$ragenixTempDir/tsvetan-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-ssh-ed25519-private" "$secretTsvetanKeyPath"

nix build '.#nixos-tsvetan-stable' # pre-build the image

sudo env "PATH=$PATH" disko-install \
	--flake "$FLAKE_ROOT#nixos-tsvetan-stable" \
	--mode format \
	--debug \
	--disk system "$(realpath "$systemDeviceBlock")" \
	--extra-files "$ragenixTempDir/tsvetan-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key

# FIXME(Krey): Flash u-boot, currently blocked by https://github.com/OLIMEX/DIY-LAPTOP/issues/73 (flashing it manually via SPI clamp and ch341a programmer atm)

# FIXME(Krey): Flash firmware for keyboard
# FIXME(Krey): Flash firmware for touchpad
