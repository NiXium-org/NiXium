{ self, inputs, ... }:

# Flake management of SINNENFREUDE system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."sinnenfreude" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			# FIXME(Krey): Do Nouveau
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this
		};

		modules = [
			self.nixosModules.default
			self.nixosModules.users-kreyren

			self.inputs.ragenix.nixosModules.default
			# self.disko-nixpkgs.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			# self.inputs.home-manager-nixpkgs.nixosModules.home-manager
			# {
			# 	home-manager.users.raptor = import ../../nixos/users/kreyren/home/machines/sinnenfreude/home-configuration.nix;
			# }
			# self.homeManagerModules.kreyren.default

			./configuration.nix
			./hardware-configuration.nix
			./impermenance.nix
			# ./disko.nix # FIXME(Krey): I don't know how to implement that yet
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};
		};
	};
}
