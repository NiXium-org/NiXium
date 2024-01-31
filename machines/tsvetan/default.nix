{ self, inputs, config, ... }:

# Flake management of TSVETAN system

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
			self.inputs.ragenix.nixosModules.default
			self.inputs.impermanence.nixosModules.impermanence
			./configuration.nix
			./hardware-configuration.nix
			# ./kernel.nix
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = true;
			};
			# For cross-compilation of e.g. linux kernel as we don't have powerful enough aarch64-linux machine for it
			crossPkgs = import inputs.nixpkgs {
				buildPlatform = "x86_64-linux";
				hostPlatform = "aarch64-linux";
				system = "aarch64-linux";
				config.allowUnfree = true;
			};
		};
	};
}
