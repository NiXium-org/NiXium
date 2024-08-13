{ self, lib, inputs, ... }:

# Experimental image

let
	inherit (lib) mkOverride;
in {
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-installer-minimal = inputs.nixos-generators.nixosGenerate {
			pkgs = import inputs.nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};

			inherit system;
			modules = [{
				users.users.root.password = "1234"; # Remove prior to merge

				services.sshd.enable = true;
				users.users.root.openssh.authorizedKeys.keys = [
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzh6FRxWUemwVeIDsr681fgJ2Q2qCnwJbvFe4xD15ve kreyren@fsfe.org" # Allow root access for the Super Administrator (KREYREN)
				];

				networking.wireless.enable = true; # Do Wireless
				networking.wireless.userControlled.enable = true;
				systemd.services.wpa_supplicant.wantedBy = [ "multi-user.target" ]; # Start wpa_supplicant service on startup

				# CONFIDENTIAL!
				networking.wireless.networks."SSID" = {
					hidden = true;
					psk = "PSK"; # CONFIDENTIAL!
					};
			}];
			format = "sd-aarch64";

			# specialArgs = {
			# 	myExtraArg = "foobar";
			# };
		};
	};
}
