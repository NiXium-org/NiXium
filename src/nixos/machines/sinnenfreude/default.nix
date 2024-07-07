{ self, inputs, ... }:

# Flake management of SINNENFREUDE system

# FIXME-SECURITY(Krey): To Be Managed..
# ⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️
# ⚠️ Random seed file '/boot/loader/.#bootctlrandom-seed048bca5ff68f0657' is world accessible, which is a security hole! ⚠️

{
	flake.nixosConfigurations."sinnenfreude" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this!
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default

			# An Anime Game
			self.inputs.aagl.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@sinnenfreude"

			# Files
			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/nvidia.nix
			./config/security.nix
			./config/setup.nix
			./config/suspend-then-hibernate.nix
			./config/vm-build.nix

			./services/binfmt.nix
			./services/distributedBuilds.nix
			./services/openssh.nix
			./services/tor.nix
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			inherit self;
			stable = import inputs.nixpkgs {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};

			staging = import inputs.nixpkgs-staging {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};
		};
	};

	# Task to perform installation of sinnenfreude in NixOS distribution
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-sinnenfreude-install = pkgs.writeShellApplication {
			name = "nixos-sinnenfreude-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = ''
				# FIXME-QA(Krey): This should be a runtimeInput
				die() { printf "FATAL: %s\n" "$2"; exit ;}

				[ -f "${self.nixosConfigurations.sinnenfreude.config.disko.devices.disk.system.device}" ] || die 1 "Expected device was not found, refusing to install"

				ragenixTempDir="/var/tmp/nixium"
				ragenixIdentity="$HOME/.ssh/id_ed25519"

				[ -d "$ragenixTempDir" ] || sudo mkdir "$ragenixTempDir"
				sudo chown -R "$USER:users" "$ragenixTempDir"
				sudo chmod -R 700 "$ragenixTempDir"

				[ -s "$ragenixTempDir/sinnenfreude-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/sinnenfreude-disks-password" "${self.nixosConfigurations.sinnenfreude.config.age.secrets.sinnenfreude-disks-password.file}"

				[ -s "$ragenixTempDir/sinnenfreude-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/sinnenfreude-ssh-ed25519-private" "${self.nixosConfigurations.sinnenfreude.config.age.secrets.sinnenfreude-ssh-ed25519-private.file}"

				sudo disko-install \
					--flake "git+file://$FLAKE_ROOT#sinnenfreude" \
					--disk system "$(realpath ${self.nixosConfigurations.sinnenfreude.config.disko.devices.disk.system.device})" \
					--extra-files "$ragenixTempDir/sinnenfreude-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
			'';
		};

		# Declare for `nix run`
		apps.nixos-sinnenfreude-install.program = self'.packages.nixos-sinnenfreude-install;
	};

	flake.nixosModules.machine-sinnenfreude = ./lib/export.nix;
}
