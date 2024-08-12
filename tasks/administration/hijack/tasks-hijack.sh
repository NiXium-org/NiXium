# shellcheck shell=sh # POSIX

# FIXME(Krey): Implement a special task that can be called via a one-liner that will assimilate the system into nixium

hostname="$(hostname --short)" # Capture the hostname of the current system

# FIXME-QA(Krey): This should be a `runtimeInput`
die() { printf "FATAL: %s\n" "$2"; exit "${1:-1}" ;} # Termination Helper

# FIXME-QA(Krey): This should be a `runtimeInput`
# Return the default derivation for machine
defaultDerivation() {
	machine="$1"
	grep "$machine" "$FLAKE_ROOT/config/machine-derivations.conf" | sed -E 's#^(\w+)(\s)([a-z\-]+)#\3#g'
}

# If no argument is provided, then attempt to hijack the current system per hostname
[ "$#" != 0 ] || {
	derivation="$(defaultDerivation "$hostname")"

	echo "Attempting to HIJACK machine the current system with hostname '$hostname' and default derivation '$derivation'"

	nix run "$FLAKE_ROOT#$derivation-hijack"

	exit 0 # Success
}

# If only 1 argument is provided then hijack the specified machine per it's default derivation
[ "$#" != 1 ] || {
	machine="$1"
	derivation="$(defaultDerivation "$machine")"

	echo "Attempting to HIJACK machine '$machine' with derivation '$derivation'"

	nix run "$FLAKE_ROOT#$derivation-hijack"

	exit 0 # Success
}

# If special argument 'all' is used then hijack all systems (e.g. for managing malware that deployed infra-wide)
[ "$1" != "all" ] || {
	for machine in $(grep -vP "^#" "$FLAKE_ROOT/config/machine-derivations.conf" | grep -vP "^/n$" | sed -E 's#^(\w+)(\s)([a-z\-]+)#\1#g' | tr '\n' ' '); do
		derivation="$(defaultDerivation "$machine")"

		nix run "$FLAKE_ROOT#$derivation-hijack"
	done
}

# Process Arguments
distro="$1" # e.g. nixos
machine="$2" # e.g. tupac, tsvetan, sinnenfreude
release="${3-"stable"}" # Optional argument uses stable as default, ability to set supported release e.g. unstable or master

case "$distro" in
	"nixos") # NixOS Management
		nixosSystems="$(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' ')" # Get a space-separated list of all systems in the nixos distribution of NiXium

		# Hijack all systems in NixOS distribution if `nixos all` is used
		[ "$machine" != "all" ] || {
			for machine in $nixosSystems; do
				status="$(cat "$FLAKE_ROOT/src/nixos/machines/$machine/status")"
				case "$status" in
					"OK")
						derivation="$(defaultDerivation "$machine")"
						echo "Attempting to HIJACK machine '$machine' in NixOS distribution with derivation '$derivation'"

						# TODO(Krey): Run a custom nix run command here that is declared within the system to perform nixos-anywhere payload
					;;
					"WIP") echo "Configuration for system '$machine' in distribution '$distro' is marked a Work-in-Progress, skipping build.." ;;
					*) echo "System '$machine' reports undeclared status state: $status"
				esac
			done
		}

		# Check if the system is defined
		[ -d "$FLAKE_ROOT/src/nixos/machines/$machine" ] || die 1 "This system '$machine' is not implemented in NiXium's management of distribution '$distro'"

		# Process the system
		echo "Attempting to hijack machine '$machine' in distribution '$distro' and release '$release'"

		# TODO(Krey): Run a custom nix run command here that is declared within the system to perform nixos-anywhere payload
	;;
	*) die 1 "Distribution '$distro' is not implemented for hijacking!"
esac
