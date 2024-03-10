{ self, inputs, config, ... }:

{
	flake.nixosConfigurations."installer" = inputs.nixpkgs.lib.nixosSystem {
			system = "riscv64-linux";
			pkgs = import inputs.nixpkgs {
				system = "riscv64-linux";
				config.allowUnfree = true;
			};

			modules = [
				# ./configuration.nix

				self.inputs.nixos-generators.nixosModules.all-formats
			];

			# FIXME-QA(Krey): This needs better management
			specialArgs = {
				unstable = import inputs.nixpkgs-unstable {
					system = "riscv64-linux";
					config.allowUnfree = true;
				};
				# For cross-compilation of e.g. linux kernel as we don't have powerful enough aarch64-linux machine for it
				# crossPkgs = import inputs.nixpkgs {
				# 	# buildPlatform = "x86_64-linux";
				# 	# hostPlatform = "aarch64-linux";
				# 	system = "x86_64-linux";
				# 	crossSystem = "aarch64-linux";
				# 	config.allowUnfree = true;
				# };
			};
		};
}
