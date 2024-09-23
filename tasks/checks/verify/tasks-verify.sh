# shellcheck shell=sh # POSIX
set +u # Do not fail on nounset as we use command-line arguments for logic

hostname="$(hostname --short)" # Capture the hostname of the current system

# FIXME(Krey): Implement better management for this so that ideally `die` is always present by default
command -v die 1>/dev/null || die() { printf "FATAL: %s\n" "$2"; exit 1 ;} # Termination Helper

# Check current system if no argument is provided
[ "$#" != 0 ] || {
	# FIXME(Krey): This needs logic to determine the distribution and release
	echo "Checking current system: $hostname"

	nixos-rebuild dry-build \
		--flake "git+file://$FLAKE_ROOT#nixos-$hostname-stable" \
		--option eval-cache false \
		--show-trace || die 1 "Verification of the current system failed"

	exit 0 # Success
}

# FIXME-QA(Krey): Hacky af
nixosSystems="$(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' ')" # Get a space-separated list of all systems in the nixos distribution of NiXium

# If special argument 'all' is used then verify all systems across all distributions and all releases
[ "$1" != "all" ] || {
	# FIXME(Krey): Once we have more distros this needs management
	distro="nixos"

	# NixOS Distribution
	for system in $nixosSystems; do
		status="$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")"

		case "$status" in
			"OK")
				for release in $(find "$FLAKE_ROOT/src/nixos/machines/$system/releases/"* -maxdepth 0 -type f | sed -E "s#^$FLAKE_ROOT/src/nixos/machines/$system/releases/##g" | sed -E "s#.nix##g" | tr '\n' ' '); do
					echo "Checking system '$system' in distribution '$distro', release '$release'"

					nixos-rebuild \
						dry-build \
						--flake "git+file://$FLAKE_ROOT#nixos-$system-$release" \
						--option eval-cache false \
						--show-trace || die 1 "System '$system' in distribution '$distro' of release '$release' failed evaluation!"
				done
			;;
			"WIP") echo "Configuration for system '$system' in distribution '$distro' is marked a Work-in-Progress, skipping build.." ;;
			*) echo "System '$system' reports undeclared status state: $status"
		esac
	done
}

# Assume that we are always checking against nixos distribution with stable release
[ "$#" != 1 ] || {
	system="$1"

	echo "Checking stable release of system '$system' in NixOS distribution"

	nixos-rebuild dry-build \
		--flake "git+file://$FLAKE_ROOT#nixos-$system-stable" \
		--option eval-cache false \
		--show-trace || die 1 "Verification of the '$system' system on NixOS distribution using stable release failed"

	exit 0 # Success
}

# If special argument `all` is used as second argument then process all releases and distros that match the first argument as system name
[ "$2" != "all" ] ||  {
	system="$1"

	echo "Checking all distributions that contain machine '$1'"

	# NixOS Distribution
	status="$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")"
	distro="nixos"

	case "$status" in
		"OK")
			for release in $(find "$FLAKE_ROOT/src/nixos/machines/$system/releases/"* -maxdepth 0 -type d | sed -E "s#^$FLAKE_ROOT/src/nixos/machines/$system/releases/##g" | sed -E "s#.nix##g" | tr '\n' ' '); do
				echo "Checking system '$system' in distribution '$distro', release '$release'"

				nixos-rebuild \
					dry-build \
					--flake "git+file://$FLAKE_ROOT#nixos-$system-$release" \
					--option eval-cache false \
					--show-trace || die 1 "System '$system' in distribution '$distro' of release '$release' failed evaluation!"
			done
		;;
		"WIP") echo "Configuration for system '$system' in distribution '$distro' is marked a Work-in-Progress, skipping build.." ;;
		*) echo "System '$system' reports undeclared status state: $status"
	esac

	exit 0 # Success
}

# Process Arguments
distro="$1" # e.g. nixos
machine="$2" # e.g. tupac, tsvetan, sinnenfreude or special `all`
release="$3" # Optional argument uses stable as default, ability to set supported release e.g. unstable or master

case "$distro" in
	"nixos") # NixOS Management

		# Process all systems in NixOS distribution if `nixos all` is used
		[ "$2" != "all" ] || {
			for system in $nixosSystems; do
				status="$(cat "$FLAKE_ROOT/src/nixos/machines/$system/status")"
				case "$status" in
					"OK")
						echo "Checking release '$release' of distribution '$distro' for system '$system'"

						nixos-rebuild \
							dry-build \
							--flake "git+file://$FLAKE_ROOT#nixos-$system-$release" \
							--option eval-cache false \
							--show-trace || echo "WARNING: System '$system' in distribution '$distro' failed evaluation!"
					;;
					"WIP") echo "Configuration for system '$system' in distribution '$distro' is marked a Work-in-Progress, skipping build.." ;;
					*) echo "System '$system' reports undeclared status state: $status"
				esac
			done
		}

		# Check if the system is defined
		[ -d "$FLAKE_ROOT/src/nixos/machines/$machine" ] || die 1 "This system '$machine' is not implemented in NiXium's management of distribution '$distro'"

		[ -n "$3" ] || {
			echo "Processing all available releases for machine '$machine' in distribution '$distro'"

			for release in $(find "$FLAKE_ROOT/src/nixos/machines/$machine/releases/"* -maxdepth 0 -type f | sed -E "s#^$FLAKE_ROOT/src/nixos/machines/$machine/releases/##g" | sed -E "s#.nix##g" | tr '\n' ' '); do
				echo "Checking system '$machine' in distribution '$distro', release '$release'"

				nixos-rebuild \
					dry-build \
					--flake "git+file://$FLAKE_ROOT#nixos-$machine-$release" \
					--option eval-cache false \
					--show-trace || die 1 "System '$machine' in distribution '$distro' of release '$release' failed evaluation!"
			done

			exit 0 # Success
		}

		# Process the system
		echo "Checking system '$machine' in distribution '$distro' and release '$release'"

		nixos-rebuild \
			dry-build \
			--flake "git+file://$FLAKE_ROOT#nixos-$machine-$release" \
			--option eval-cache false \
			--show-trace || die 1 "System '$machine' in distribution '$distro' and release '$release' failed evaluation"
	;;
	*) die 1 "Distribution '$distro' is not implemented!"
esac
