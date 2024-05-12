{ self, inputs, config, ... }:

{
	flake.nixosConfigurations."installer" = inputs.nixpkgs.lib.nixosSystem {
			system = "riscv64-linux";
			pkgs = import inputs.nixpkgs {
				system = "riscv64-linux";
				config.allowUnfree = true;
			};

			modules = [
				./configuration.nix

				"${self.inputs.nixpkgs}/nixos/modules/installer/cd-dvd
/installation-cd-minimal.nix"

				self.inputs.nixos-generators.nixosModules.all-formats

				{
					nixpkgs.config.allowUnsupportedSystem = true; # LEEEEROOOOYY JEEEENKIIINSSSSS
					nixpkgs.hostPlatform.system = "riscv64-linux";
					nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
					# ... extra configs as above
				}
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
