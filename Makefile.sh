#!/usr/bin/env sh
# shellcheck shell=sh # POSIX

# Prepared for deprecation..

# Stop laughing, fuck you! This is Proof-of-concept implementation for me to figure out how i want it work so that i can later implement it in e.g. rust

set -e # Exit on false return

# Concept of project management solution

die() { printf "FATAL: %s\n" "$2"; exit 1 ;} # Assertion helper
einfo() { ${PRINTF:-"printf"} "INFO: %s\n" "$1" ;} # Output helper

repoDir="$(pwd)" # Get the full path to the repository's directory

# Process arguments
while [ "$#" -gt 0 ]; do case "$1" in
	"verify")
		[ -n "$2" ] || die 3 "The verify sub-command requires a SYSTEM as second argument"

		einfo "Verifying the configuration for system: $2"

		${NIXOS_REBUILD:-"nixos-rebuild"} dry-build \
			--flake ".#$2" \
			--option eval-cache false || einfo "Config verification of '$system' failed"

		shift
	;;
	"build"|"test"|"boot"|"switch"|"dry-build")
		case "$2" in
			"all")
				task="$1"

				for system in "$repoDir"/machines/*; do
					einfo "Building system '$system'"

					${NIXOS_REBUILD:-"nixos-rebuild"} "$task" \
						--flake ".#$system" || einfo "System '$system' couldn't be built?, err $?"
				done

				shift # Shift 2nd arg
			;;
			# "") # For the host system
			# 	task="$1"

			# 	einfo "Building system '$system'"

			# 	HOSTNAME="$system" ${NIXOS_REBUILD:-"nixos-rebuild"} "$task" \
			# 		--flake ".#$system" || einfo "System '$system' couldn't be built?, err $?"
			# ;;
			*) # All other systems
				system="$2"
				task="$1"

				einfo "Building system '$system'"

				${NIXOS_REBUILD:-"nixos-rebuild"} "$task" \
					--flake ".#$system" || einfo "System '$system' couldn't be built?, err $?"

				shift # Shift 2nd arg
		esac ;;
	"deploy")
		case "$2" in
			"all")
				for system in "$repoDir"/machines/*; do
					einfo "Building system '$system'"

					die 1 "currently not implemented"

					${NIXOS_REBUILD:-"nixos-rebuild"} switch \
						--target-host "builder@$system.nixium" \
						--flake ".#$system" || einfo "System '$system' couldn't be built?, err $?"

					einfo "Configuration has been deployed in system '$system', but it needs to be activated manually"
				done
			;;
			*)
				system="$2"

				einfo "Building system '$system'"

				${NIXOS_REBUILD:-"nixos-rebuild"} switch \
					--target-host "builder@$system.nixium" \
					--flake ".#$system" || einfo "System '$system' couldn't be built?, err $?"

				shift # Shift 2nd arg
		esac
	;;
	"ping")
		echo test
	;;
	*) die 2 "Wrong input: $1"
esac; shift; done
