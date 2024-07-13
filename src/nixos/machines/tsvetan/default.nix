{ self, lib, inputs, ... }:

# Flake management of TSVETAN system

let
	inherit (lib) mkForce;
in {
	# Main Configuration
	flake.nixosConfigurations."tsvetan" = inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		pkgs = import inputs.nixpkgs {
			system = "aarch64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
		};

		modules = [
			self.nixosModules.default # Load NiXium's Global configuration

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default
			self.inputs.nixos-generators.nixosModules.all-formats

			# Users
			self.nixosModules.users-kreyren
			self.homeManagerModules."kreyren@tsvetan"

			# Files
			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/power-management.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
			./config/vm-build.nix

			./services/distributedBuilds.nix
			./services/openssh.nix
			./services/tor.nix
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Task to perform installation of TSVETAN in NixOS distribution
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-tsvetan-install = pkgs.writeShellApplication {
			name = "nixos-tsvetan-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = ''
				# FIXME-QA(Krey): This should be a runtimeInput
				die() { printf "FATAL: %s\n" "$2"; exit ;}

				[ -f "${self.nixosConfigurations.tsvetan.config.disko.devices.disk.system.device}" ] || die 1 "Expected device was not found, refusing to install"

				ragenixTempDir="/var/tmp/nixium"
				ragenixIdentity="$HOME/.ssh/id_ed25519"

				[ -d "$ragenixTempDir" ] || sudo mkdir "$ragenixTempDir"
				sudo chown -R "$USER:users" "$ragenixTempDir"
				sudo chmod -R 700 "$ragenixTempDir"

				[ -s "$ragenixTempDir/tsvetan-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-disks-password" "${self.nixosConfigurations.tsvetan.config.age.secrets.tsvetan-disks-password.file}"

				[ -s "$ragenixTempDir/tsvetan-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tsvetan-ssh-ed25519-private" "${self.nixosConfigurations.tsvetan.config.age.secrets.tsvetan-ssh-ed25519-private.file}"

				sudo disko-install \
					--flake "git+file://$FLAKE_ROOT#mracek" \
					--disk system "$(realpath ${self.nixosConfigurations.tsvetan.config.disko.devices.disk.system.device})" \
					--extra-files "$ragenixTempDir/tsvetan-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key

				# FIXME(Krey): Flash u-boot, currently blocked by https://github.com/OLIMEX/DIY-LAPTOP/issues/73 (flashing it manually via SPI clamp and ch341a programmer atm)

				# FIXME(Krey): Flash firmware for keyboard
				# FIXME(Krey): Flash firmware for touchpad
			'';
		};

		# Declare for `nix run`
		apps.nixos-tsvetan-install.program = self'.packages.nixos-tsvetan-install;
	};

	# Recovery configuration
		# FIXME(Krey): Figure out how to generate an image with u-boot starting at 128th block to not rely on the systems's firmware on SPI flash
		# BLOCKER(Krey): Should be nixosModules once https://github.com/nix-community/nixos-generators/issues/349 is fixed
	nixosConfigurations."nixos-tsvetan-recovery" = inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		pkgs = import inputs.nixpkgs {
			system = "aarch64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
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

			# Users
			self.nixosModules.users-kreyren

			{
				# WORKAROUND(Krey): https://github.com/NixOS/nixpkgs/issues/286196
				boot.loader.efi.canTouchEfiVariables = false;
			}
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# BLOCKED(Krey): https://github.com/nix-community/nixos-generators/issues/349
	packages.aarch64-linux.nixos-tsvetan-recovery = self.inputs.nixos-generators.nixosGenerate {
		system = "aarch64-linux";
		modules = [ self.nixosModules.aarch64-linux.nixos-tsvetan-recovery ];
		format = "sd-aarch64-installer";
	};

	# Declare for `nix run`
	apps.nixos-tsvetan-recovery.program = self.packages.aarch64-linux.nixos-tsvetan-recovery;

	# Module export to other systems in the infrastructure
	flake.nixosModules.machine-tsvetan = ./lib/tsvetan-export.nix;
}
