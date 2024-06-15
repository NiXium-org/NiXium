{ ... }:

# BinFMT Management of TSVETAN

{
	# Tsvetan is a hardened system with admin permissions to all systems in the infrastructure. To be able to send instructions to a different system it needs binmnt
	boot.binfmt.emulatedSystems = [
		"aarch64-linux"
		"riscv64-linux"
		"armv7l-linux"
	];
}