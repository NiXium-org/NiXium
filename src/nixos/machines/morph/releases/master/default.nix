{ inputs, lib, self,... }:

# Declaration for MASTER release of NixOS for MORPH

let
	inherit (lib) mkForce;
in {
	flake.nixosConfigurations."nixos-morph-master" = inputs.nixpkgs-master.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs-master {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
		};

		modules = [
			self.nixosModules."nixos-morph"

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

	# Task to perform installation of morph in NixOS distribution, master release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-morph-master-install = pkgs.writeShellApplication {
				name = "nixos-morph-master-install";
				bashOptions = [
					"errexit" # Exit on False Return
					"posix" # Run in POSIX mode
				];
				runtimeInputs = [
					inputs'.disko.packages.disko-install # disko-install
					pkgs.age # age
					pkgs.nixos-install-tools # nixos-install
					pkgs.gawk # awk
					pkgs.curl
					pkgs.jq
				];
				runtimeEnv = {
					systemDevice = self.nixosConfigurations.nixos-morph-stable.config.disko.devices.disk.system.device;

					secretPasswordPath = self.nixosConfigurations.nixos-morph-stable.config.age.secrets.morph-disks-password.file;

					secretSSHHostKeyPath = self.nixosConfigurations.nixos-morph-stable.config.age.secrets.morph-ssh-ed25519-private.file;
				};
				text = builtins.readFile ./morph-nixos-master-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-morph-master-install.program = self'.packages.nixos-morph-master-install;
	};
}
