{ self, inputs, ... }:

# Flake management of COOKIE system

# FIXME-SECURITY(Krey): To Be Managed..
# ⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️
# ⚠️ Random seed file '/boot/loader/.#bootctlrandom-seed048bca5ff68f0657' is world accessible, which is a security hole! ⚠️

{
	flake.nixosConfigurations."cookie" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true;
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

			# Users
			self.nixosModules.users-tanvir
			self.homeManagerModules."tanvir@cookie"

			# Files
			./config/bootloader.nix
			./config/disks.nix
			./config/firmware.nix
			./config/hardware-acceleration.nix
			./config/initrd.nix
			./config/kernel.nix
			./config/networking.nix
			./config/nvidia.nix
			./config/printing.nix
			./config/security.nix
			./config/setup.nix
			./config/sound.nix
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

	flake.nixosModules.machine-cookie = ./lib/cookie-export.nix;
}
