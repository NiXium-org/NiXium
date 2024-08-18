# Nix-Managed Shell File
#
# This is a Nix-Managed Shell File, the difference between regular shell script is that Nix is responsible for setting up the environment to enforce reproducibility and purity in which the script is executed including any desired shell libraries and functions.
# Specifically it sets shebang, PATH and shell options via internal `writeShellApplication` that also processes the script with shelcheck and terminates the evaluation on failure and prior to executing the script itself.

# shellcheck shell=sh # POSIX

hostname="$(hostname --short)" # Capture the hostname of the current system

# FIXME(Krey): Implement better management for this so that ideally `die` is always present by default
command -v die 1>/dev/null || die() { printf "FATAL: %s\n" "$2"; exit 1 ;} # Termination Helper

# FIXME(Krey): Move this into a separate function, used here only for testing..
# Check if the wanted system is on the local network, if so return it's IP and true state
findSystemIp() {
	wantedSystem="$1"

	# Get the primary network interface that is UP
	for iface in $(ip -br link show | awk '$2 == "UP" {print $1}'); do
		networkInterface="$iface"
		break
	done

	[ -n "$networkInterface" ] || die 1 "Unable to find any suitable network interfaces" >&2

	echo "Scanning the local network for system '$wantedSystem' using network interface '$networkInterface'" >&2

	# Get the IP address and subnet mask of the interface
	ip_address=$(ip -o -f inet addr show "$networkInterface" | awk '{print $4}' | cut -d/ -f1)
	subnet_mask=$(ip -o -f inet addr show "$networkInterface" | awk '{print $4}' | cut -d/ -f2)

	{ [ -z "$ip_address" ] || [ -z "$subnet_mask" ] ;} && die 1 "Unable to determine IP address or subnet mask for interface '$networkInterface'"

	# Calculate network base address
	# shellcheck disable=SC2034 # It's okay that we don't use i4
	IFS=. read -r i1 i2 i3 i4 <<-EOF
		$ip_address
	EOF

	network="$i1.$i2.$i3.0"

	# FIXME-QA(Krey): This will never be zero..
	[ -n "$network" ] || die 1 "Unable to determine network base address"

	echo "Found local network range '$network/$subnet_mask'" >&2

	# Run fping to get active IP addresses
	# FIXME-QA(Krey): I hate that this is so fragile, it should process all found IPs and then have a method that returns only the short hostname of the IP to make a logical comparison instead of regex for the record containing the hostname which might get false positive if one system's hostname contains the hostname of another e.g. system ix and system nixos
	for address in $(fping -a -g "$network/$subnet_mask" 2>/dev/null | tr '\n' ' '); do
		echo "Checking IP: $address" >&2

		record="$(dig -x "$address")"

		case "$record" in *"$wantedSystem"*)
			echo "Found system '$wantedSystem' on IP '$address'" >&2
			echo "$address"
			return 0
		esac
	done

	echo "System named '$wantedSystem' not found on the network." >&2
	return 1
}

# Check current system if no argument is provided
[ "$#" != 0 ] || {
	# FIXME(Krey): This needs logic to determine the distribution and release
	echo "Deploying Stable Release of NixOS distribution on current system '$hostname'"

	nixos-rebuild switch \
		--flake "git+file://$FLAKE_ROOT#nixos-$hostname-stable" \
		--option eval-cache false \
		--show-trace || die 1 "Deployment of the stable release of NixOS distribution on the current system failed"

	exit 0 # Success
}

# If only 1 argument is provided then deploy the configured system on said unique machine name
[ "$#" != 1 ] || {
	machine="$1"

	scanLocalNet="$(findSystemIp "$machine")"

	if [ -z "$scanLocalNet" ]; then
		targetHost="root@$machine.systems.nx"
	else
		targetHost="root@$scanLocalNet"
	fi

	derivation="$(grep "$machine" "$FLAKE_ROOT/config/machine-derivations.conf" | sed -E 's#^(\w+)(\s)([a-z\-]+)#\3#g')"

	echo "Deploying configured derivation for '$machine', which is: $derivation"

	nixos-rebuild switch \
		--flake "git+file://$FLAKE_ROOT#$derivation" \
		--option eval-cache false \
		--target-host "$targetHost" || die 1 "Deployment of the configured derivation '$derivation' on machine '$machine' failed"

		exit 0 # Success
}

# If special argument 'all' is used then deploy the specified distribution and release on all systems
[ "$1" != "all" ] || {
	for system in $(grep -vP "^#" "$FLAKE_ROOT/config/machine-derivations.conf" | grep -vP "^/n$" | sed -E 's#^(\w+)(\s)([a-z\-]+)#\1#g' | tr '\n' ' '); do
		derivation="$(grep mracek "$FLAKE_ROOT/config/machine-derivations.conf" | sed -E 's#^(\w+)(\s)([a-z\-]+)#\3#g')"

		nixos-rebuild switch \
		--flake "git+file://$FLAKE_ROOT#$derivation" \
		--option eval-cache false \
		--target-host "root@$system.systems.nx" || echo "WARNING: derivation '$derivation' failed deployment for system '$system'"
	done
}

# Process Arguments
distro="$1" # e.g. nixos
machine="$2" # e.g. tupac, tsvetan, sinnenfreude
release="${3-"stable"}" # Optional argument uses stable as default, ability to set supported release e.g. unstable or master

case "$distro" in
	"nixos") # NixOS Management
		nixosSystems="$(find "$FLAKE_ROOT/src/nixos/machines/"* -maxdepth 0 -type d | sed "s#^$FLAKE_ROOT/src/nixos/machines/##g" | tr '\n' ' ')" # Get a space-separated list of all systems in the nixos distribution of NiXium

		# Process all systems in NixOS distribution if `nixos all` is used
		[ "$machine" != "all" ] || {
			for machine in $nixosSystems; do
				status="$(cat "$FLAKE_ROOT/src/nixos/machines/$machine/status")"
				case "$status" in
					"OK")
						echo "Deploying NixOS distribution release '$release' on machine '$machine'"

						nixos-rebuild switch \
							--flake "git+file://$FLAKE_ROOT#nixos-$machine-$release}" \
							--option eval-cache false \
							--target-host "root@$machine.systems.nx" || die 1 "System '$machine' in distribution '$distro' and release '$release' failed deployment!"
					;;
					"WIP") echo "Configuration for system '$machine' in distribution '$distro' is marked a Work-in-Progress, skipping build.." ;;
					*) echo "System '$machine' reports undeclared status state: $status"
				esac
			done
		}

		# Check if the system is defined
		[ -d "$FLAKE_ROOT/src/nixos/machines/$machine" ] || die 1 "This system '$machine' is not implemented in NiXium's management of distribution '$distro'"

		# Process the system
		echo "Deploying system '$machine' in distribution '$distro' and release '$release'"

		nixos-rebuild \
			switch \
			--flake "git+file://$FLAKE_ROOT#nixos-$machine-$release" \
			--option eval-cache false \
			--target-host "root@$machine.systems.nx"  || echo "WARNING: System '$machine' in distribution '$distro' failed evaluation!"
	;;
	*) die 1 "Distribution '$distro' is not implemented for deployments!"
esac
