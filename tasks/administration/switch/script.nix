{ pkgs, ... }:

# Task to SWITCH the hostname-defined or specified derivation on current system

{
	switch-task = pkgs.writeShellScriptBin "switch-task" ''
		case "$*" in
			"")
				hostname="$(hostname --short)"
				echo "Switching configuration for system: $hostname"

				${pkgs.openssh}/bin/ssh root@localhost \
					${pkgs.nixos-rebuild}/bin/nixos-rebuild \
						switch \
							--flake "git+file://$FLAKE_ROOT#$hostname" \
							--option eval-cache false
				;;
			*)
				echo "Switching configuration for system: $*"

				${pkgs.nixos-rebuild}/bin/nixos-rebuild \
					switch \
						--flake "git+file://$FLAKE_ROOT#$*" \
						--target-host "root@$*.systems.nx" \
						--option eval-cache false
		esac
	'';
}

