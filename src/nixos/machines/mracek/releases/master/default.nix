{ inputs, lib, self,... }:

# Declaration for MASTER release of NixOS for MRACEK

let
	inherit (lib) mkForce;
in {
	flake.nixosConfigurations."nixos-mracek-master" = inputs.nixpkgs-master.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-master {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
		};

		modules = [
			self.nixosModules."nixos-mracek"

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

			# An Anime Game
			self.inputs.aagl-master.nixosModules.default {
				networking.mihoyo-telemetry.block = true; # Block miHoYo telemetry servers
				nix.settings = {
					substituters = [ "https://ezkea.cachix.org" ];
					trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
				};
			}
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "x86_64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Task to perform installation of MRACEK in NixOS distribution, master release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-mracek-master-install = pkgs.writeShellApplication {
				name = "nixos-mracek-master-install";
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
					systemDevice = self.nixosConfigurations.nixos-mracek-master.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-mracek-master.config.disko.devices.disk.system.device;

					secretPasswordPath = self.nixosConfigurations.nixos-mracek-master.config.age.secrets.mracek-disks-password.file;

					secretSSHHostKeyPath = self.nixosConfigurations.nixos-mracek-master.config.age.secrets.mracek-ssh-ed25519-private.file;
				};
				text = builtins.readFile ./mracek-nixos-master-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-mracek-master-install.program = self'.packages.nixos-mracek-master-install;
	};
}
