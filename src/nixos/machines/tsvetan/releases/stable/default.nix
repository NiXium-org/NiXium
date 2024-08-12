{ self, lib, inputs, ... }:

# Declaration for STABLE release of NixOS for TSVETAN

let
	inherit (lib) mkForce;
in {
	flake.nixosConfigurations."nixos-tsvetan-stable" = self.inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		pkgs = import inputs.nixpkgs {
			system = "aarch64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
		};

		modules = [
			self.nixosModules."nixos-tsvetan"

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default
			self.inputs.nixos-generators.nixosModules.all-formats
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
		packages.nixos-tsvetan-stable-install = pkgs.writeShellApplication {
			name = "nixos-tsvetan-stable-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install # disko-install
				pkgs.age # age
				pkgs.nixos-install-tools # nixos-install
				pkgs.gawk # awk
			];
			runtimeEnv = {
				systemDevice = self.nixosConfigurations.nixos-tsvetan-stable.config.disko.devices.disk.system.device;

				systemDeviceBlock = self.nixosConfigurations.nixos-tsvetan-stable.config.disko.devices.disk.system.device;

				secretTsvetanPasswordPath = self.nixosConfigurations.nixos-tsvetan-stable.config.age.secrets.tsvetan-disks-password.path;

				secretTsvetanKeyPath = self.nixosConfigurations.nixos-tsvetan-stable.config.age.secrets.tsvetan-ssh-ed25519-private.path;
			};
			text = builtins.readFile ./tsvetan-nixos-stable-deploy.sh;
		};

		# Declare for `nix run`
		apps.nixos-tsvetan-stable-install.program = self'.packages.nixos-tsvetan-stable-install;
	};

	# Recovery configuration
		# FIXME(Krey): Figure out how to generate an image with u-boot starting at 128th block to not rely on the systems's firmware on SPI flash
	# flake.packages.nixos-tsvetan-recovery.sd-aarch64-installer = self.inputs.nixos-generators.nixosGenerate {
	# 	system = "aarch64-linux";
	# 	modules = [
	# 		self.nixosModules.default # Load NiXium's Global configuration

	# 		# Principles
	# 		self.inputs.ragenix.nixosModules.default
	# 		self.inputs.sops.nixosModules.sops
	# 		self.inputs.hm.nixosModules.home-manager
	# 		self.inputs.disko.nixosModules.disko
	# 		self.inputs.lanzaboote.nixosModules.lanzaboote
	# 		self.inputs.impermanence.nixosModules.impermanence
	# 		self.inputs.arkenfox.hmModules.default
	# 		self.inputs.nixos-generators.nixosModules.all-formats

	# 		# Users
	# 		self.nixosModules.users-kreyren

	# 		{
	# 			# WORKAROUND(Krey): https://github.com/NixOS/nixpkgs/issues/286196
	# 			boot.loader.efi.canTouchEfiVariables = false;
	# 		}
	# 	];
	# 	format = "sd-aarch64-installer";
	# };

	# # Declare for `nix run`
	# flake.apps.nixos-tsvetan-recovery.program = self.packages.nixos-tsvetan-recovery.sd-aarch64-installer;
}
