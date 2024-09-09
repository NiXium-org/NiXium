{ inputs, lib, self,... }:

# Declaration for UNSTABLE release of NixOS for TUPAC

{
	flake.nixosConfigurations."nixos-tupac-unstable" = inputs.nixpkgs-unstable.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-unstable {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this!
		};

		modules = [
			self.nixosModules."nixos-tupac"

			# Principles
			self.inputs.ragenix-unstable.nixosModules.default
			self.inputs.sops-unstable.nixosModules.sops
			self.inputs.hm-unstable.nixosModules.home-manager
			self.inputs.disko-unstable.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default
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

	# Task to perform installation of TUPAC in NixOS distribution, unstable release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-tupac-unstable-install = pkgs.writeShellApplication {
				name = "nixos-tupac-unstable-install";
				bashOptions = [ "errexit" "xtrace" ];
				runtimeInputs = [
					inputs'.disko.packages.disko-install # disko-install
					pkgs.age # age
					pkgs.nixos-install-tools # nixos-install
					pkgs.gawk # awk
					pkgs.curl
					pkgs.jq
				];
				runtimeEnv = {
					systemDevice = self.nixosConfigurations.nixos-tupac-unstable.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-tupac-unstable.config.disko.devices.disk.system.device;

					secretPasswordPath = self.nixosConfigurations.nixos-tupac-unstable.config.age.secrets.tupac-disks-password.file;

					secretSSHHostKeyPath = self.nixosConfigurations.nixos-tupac-unstable.config.age.secrets.tupac-ssh-ed25519-private.file;
				};
				text = builtins.readFile ./tupac-nixos-unstable-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-tupac-unstable-install.program = self'.packages.nixos-tupac-unstable-install;
	};
}
