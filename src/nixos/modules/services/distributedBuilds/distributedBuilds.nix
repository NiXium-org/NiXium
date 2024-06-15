{ config, lib, pkgs, ... }:

# Global configuration of monero

let
	inherit (lib) mkIf;

	builder-account = "builder";
	builder-group = "builder";
	builder-key-path = "/etc/ssh/";

in mkIf config.nix.distributedBuilds {
#in {
	# Setup the builder user
		users.groups."${builder-group}" = {}; # Create 'builder' user group

		# Add the builder user
			users.users."${builder-account}" = {
				description = "User used for distributed builds on nixium";
				isNormalUser = true;
				createHome = false;
				group = builder-group;

				# To add global authorized users
				# openssh.authorizedKeys.keys = [
				# 	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve" # RAPTOR
				# ];
			};

		# Authorize the builder user in the nix daemon
			# NOTE-SECURITY(Krey): Avoid the use of `trusted-users` as those can set up additional binary cache and import **UNSIGNED** nars, in case the system gets compromised this would be a liability where `allowed-users` address this issue
			# NOTE-SECURITY(The Future Krey): Complaines about trusted keys unless it's in `trusted-users`, investigate whether this is a good idea or if there is a more reasonable way around it
			# nix.settings.allowed-users = [ builder-account ]; # Add builder in the allowed users
			nix.settings.trusted-users = [ builder-account ]; # Add builder in the allowed users

		# Generate the SSH Key for the builder user
			# FIXME-PURITY(Krey): This is a bad management for impermenant systems instead the keys should be age-encrypted and imported to the invidual systems
		systemd.services.builder-ssh = {
			# NOTE(Krey): This whole declaration is hidden behind `mkIf config.nix.distributedBuilds` thus simple `true` works here fine
			enable = true;

			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" ];
			description = "Generate unique SSH key for the distribute builds";
			script = ''
				[ -f "${builder-key-path}/ssh_${builder-account}_ed25519_key.pub" ] || {
					# Generate the SSH Key with `ssh-keygen`
					${pkgs.openssh}/bin/ssh-keygen \
						-C "" \
						-t ed25519 \
						-N "" \
						-f "${builder-key-path}/ssh_${builder-account}_ed25519_key"
				}

				# Make sure it has the correct permissions
				${pkgs.busybox}/bin/chown ${builder-account}:${builder-group} ${builder-key-path}/ssh_${builder-account}_ed25519_key{,.pub} # Set file ownership

				${pkgs.busybox}/bin/chmod 770 ${builder-key-path}/ssh_${builder-account}_ed25519_key{,.pub} # Set file permissions
			'';
};
}
