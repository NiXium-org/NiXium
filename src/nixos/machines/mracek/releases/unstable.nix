{ inputs, lib, self,... }:

# Declaration for UNSTABLE release of NixOS for MRACEK

let
	inherit (lib) mkForce;
in {
	flake.nixosConfigurations."nixos-mracek-unstable" = inputs.nixpkgs-unstable.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-unstable {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
		};

		modules = [
			self.nixosModules."nixos-mracek"

			# Principles
			self.inputs.ragenix-unstable.nixosModules.default
			self.inputs.sops-unstable.nixosModules.sops
			self.inputs.hm-unstable.nixosModules.home-manager
			self.inputs.disko-unstable.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default

			# An Anime Game
			self.inputs.aagl-unstable.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Task to perform installation of MRACEK in NixOS distribution
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-mracek-unstable-install = pkgs.writeShellApplication {
			name = "nixos-mracek-unstable-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = ''
				# FIXME-QA(Krey): This should be a runtimeInput
				die() { printf "FATAL: %s\n" "$2"; exit ;}

				[ -f "${self.nixosConfigurations.mracek.config.disko.devices.disk.system.device}" ] || die 1 "Expected device was not found, refusing to install"

				ragenixTempDir="/var/tmp/nixium"
				ragenixIdentity="$HOME/.ssh/id_ed25519"

				[ -d "$ragenixTempDir" ] || sudo mkdir "$ragenixTempDir"
				sudo chown -R "$USER:users" "$ragenixTempDir"
				sudo chmod -R 700 "$ragenixTempDir"

				[ -s "$ragenixTempDir/mracek-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-disks-password" "${self.nixosConfigurations.mracek.config.age.secrets.mracek-disks-password.file}"

				[ -s "$ragenixTempDir/mracek-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-ssh-ed25519-private" "${self.nixosConfigurations.mracek.config.age.secrets.mracek-ssh-ed25519-private.file}"

				sudo disko-install \
					--flake "git+file://$FLAKE_ROOT#mracek" \
					--disk system "$(realpath ${self.nixosConfigurations.mracek.config.disko.devices.disk.system.device})" \
					--extra-files "$ragenixTempDir/mracek-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
			'';
		};

		# Declare for `nix run`
		apps.nixos-mracek-unstable-install.program = self'.packages.nixos-mracek-unstable-install;
	};
}
