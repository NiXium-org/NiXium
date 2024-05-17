{ self, inputs, config, ... }:

# Flake management of TSVETAN system

# Use `$ nix build .#nixosConfigurations.tsvetan.config.formats.sd-aarch64` to build an sdcard image

# TODO(Krey): Address this
# > ⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️
# > ⚠️ Random seed file '/boot/loader/random-seed' is world accessible, which is a security hole! ⚠️

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."tsvetan" = inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		# Basically you just want something like `(import inputs.nixpkgs { buildPlatform = "x86_64-linux"; hostPlatform = "aarch64-linux"; }).buildLinux`
		pkgs = import inputs.nixpkgs {
			system = "aarch64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.hm.nixosModules.home-manager
			#self.inputs.nixos-generators.nixosModules.all-formats # Figure out later

			# Users
			self.nixosModules.users-kreyren # Add KREYREN user
			self.homeManagerModules."kreyren@tsvetan"

			# Files
			./configuration.nix
			./hardware-configuration.nix
			# ./kernel.nix
			./suspend.nix # Suspend-then-hibernate management
			./distributedBuilds.nix # Enable distributed builds
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			inherit self;
			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = true;
			};
			# For cross-compilation of e.g. linux kernel as we don't have powerful enough aarch64-linux machine for it
			crossPkgs = import inputs.nixpkgs {
				# buildPlatform = "x86_64-linux";
				# hostPlatform = "aarch64-linux";
				system = "x86_64-linux";
				crossSystem = "aarch64-linux";
				config.allowUnfree = true;
			};
		};
	};

	# flake.nixosConfigurations."tsvetan-sdcard" = inputs.nixpkgs.lib.nixosSystem {
	# 	system = "aarch64-linux";

	# 	# Basically you just want something like `(import inputs.nixpkgs { buildPlatform = "x86_64-linux"; hostPlatform = "aarch64-linux"; }).buildLinux`
	# 	pkgs = import inputs.nixpkgs {
	# 		system = "aarch64-linux";
	# 		config.allowUnfree = true;
	# 	};

	# 	modules = [
	# 		self.nixosModules.default
	# 		self.inputs.ragenix.nixosModules.default
	# 		self.inputs.impermanence.nixosModules.impermanence

	# 		self.nixosModules.users-kreyren

	# 		./configuration.nix
	# 		./hardware-configuration.nix
	# 		./kernel.nix # Attempt at tinyconfig

	# 		self.inputs.nixos-generators.nixosModules.all-formats
	# 	];

	# 	# FIXME-QA(Krey): This needs better management
	# 	specialArgs = {
	# 		unstable = import inputs.nixpkgs-unstable {
	# 			system = "aarch64-linux";
	# 			config.allowUnfree = true;
	# 		};
	# 		# For cross-compilation of e.g. linux kernel as we don't have powerful enough aarch64-linux machine for it
	# 		crossPkgs = import inputs.nixpkgs {
	# 			# buildPlatform = "x86_64-linux";
	# 			# hostPlatform = "aarch64-linux";
	# 			system = "x86_64-linux";
	# 			crossSystem = "aarch64-linux";
	# 			config.allowUnfree = true;
	# 		};
	# 	};
	# };
}
