{ self, inputs, ... }:

# Flake management of LP4A system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."lp4a" = inputs.nixpkgs.lib.nixosSystem {
		system = "riscv64-linux";

		# pkgs = import inputs.nixpkgs {
		# 	system = "riscv64-linux";
		# 	config.allowUnfree = true;
		# };

		# Cross-Compile all packages on x86_64-linux, usually this would be undesirable as nix's cache is built through binfmt, but such cache is non-existant atm
		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			crossSystem = "riscv64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.home-manager.nixosModules.home-manager
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.nixos-generators.nixosModules.all-formats

			# Users
			self.nixosModules.users-kreyren
			# self.homeManagerModules."kreyren@lp4a"

			# Files
			./configuration.nix
			./hardware-configuration.nix

			{
				formatConfigs.raw-efi = { config, ... }: {
				boot.kernelParams = [ "console=tty0" ];
				users.users.root.password = "lp4a"; # SECURITY(Krey): IF SOMEONE CONNECTS THIS TO THE FUCKING LOCAL NETWORK I WILL RIP THEIR HEAD OFF
				users.mutableUsers = true;
				};
			}
		];

		# FIXME-QA(Krey): This needs better management
		# specialArgs = {
		# 	unstable = import inputs.nixpkgs-unstable {
		# 		system = "x86_64-linux";
		# 		config.allowUnfree = true;
		# 	};
		# };
	};
}
