{ self, config, lib, inputs, ... }:

# Flake management of MRACEK system

let
	inherit (lib) mkForce;
in {
	# Main Configuration
	flake.nixosConfigurations."mracek" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
		};

		modules = [
			self.nixosModules.default # Load NiXium's Global configuration

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.disko.nixosModules.disko
			self.inputs.nixos-generators.nixosModules.all-formats

			# Files
			./services/binfmt.nix
			./services/distributedBuilds.nix
			./services/gitea.nix
			./services/monero.nix
			./services/murmur.nix
			./services/navidrome.nix
			./services/openssh.nix
			./services/tor.nix
			./services/vaultwarden.nix
			./services/vikunja.nix

			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/power-management.nix
			./config/remote-unlock.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
			./config/vm-build.nix
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
		packages.nixos-mracek-install = pkgs.writeShellApplication {
			name = "nixos-mracek-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = ''
				# FIXME-QA(Krey): This should be a runtimeInput
				die() { printf "FATAL: %s\n" "$2"; exit ;}

				# FIXME(Krey): Should we adapt this to allow parsing a different disk?
				# [ -f "${self.nixosConfigurations.mracek.config.disko.devices.disk.system.device}" ] || die 1 "Expected device was not found, refusing to install"

				[ -n "$ragenixTempDir" ] || ragenixTempDir="$/var/tmp/nixium"
				[ -n "$ragenixIdentity" ] || ragenixIdentity="$HOME/.ssh/id_ed25519"

				[ -d "$ragenixTempDir" ] || sudo mkdir "$ragenixTempDir"
				sudo chown -R "$USER:users" "$ragenixTempDir"
				sudo chmod -R 700 "$ragenixTempDir"

				[ -s "$ragenixTempDir/mracek-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-disks-password" "${self.nixosConfigurations.mracek.config.age.secrets.mracek-disks-password.file}"

				[ -s "$ragenixTempDir/mracek-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/mracek-ssh-ed25519-private" "${self.nixosConfigurations.mracek.config.age.secrets.mracek-ssh-ed25519-private.file}"

				sudo disko-install \
					--dry-run \
					--flake "git+file://$FLAKE_ROOT#mracek" \
					--disk system "$(realpath ${self.nixosConfigurations.mracek.config.disko.devices.disk.system.device})" \
					--extra-files "$ragenixTempDir/mracek-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
			'';
		};

		# Declare for `nix run`
		apps.nixos-mracek-install.program = self'.packages.nixos-mracek-install;
	};

	# Module export to other systems in the infrastructure
		flake.nixosModules.machine-mracek = ./lib/mracek-export.nix;
}
