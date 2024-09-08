{ inputs, lib, self,... }:

# Declaration for MASTER release of NixOS for TUPAC

{
	flake.nixosConfigurations."nixos-tupac-master" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-master {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this!
		};

		modules = [
			self.nixosModules."nixos-tupac"

			{
				nix.nixPath = [
					"nixpkgs=${self.inputs.nixpkgs-master}"
				];

				nix.registry = {
					nixpkgs = { flake = self.inputs.nixpkgs-master; };
				};
			}

			# Principles
			self.inputs.ragenix-master.nixosModules.default
			self.inputs.sops-master.nixosModules.sops
			self.inputs.hm-master.nixosModules.home-manager
			self.inputs.disko-master.nixosModules.disko
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

			unstable = import inputs.nixpkgs-master {
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

	# Task to perform installation of tupac in NixOS distribution, master release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-tupac-master-install = pkgs.writeShellApplication {
				name = "nixos-tupac-master-install";
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
					systemDevice = self.nixosConfigurations.nixos-tupac-master.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-tupac-master.config.disko.devices.disk.system.device;

					secretPasswordPath = self.nixosConfigurations.nixos-tupac-master.config.age.secrets.tupac-disks-password.file;

					secretSSHHostKeyPath = self.nixosConfigurations.nixos-tupac-master.config.age.secrets.tupac-ssh-ed25519-private.file;
				};
				text = builtins.readFile ./tupac-nixos-master-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-tupac-master-install.program = self'.packages.nixos-tupac-master-install;
	};
}
