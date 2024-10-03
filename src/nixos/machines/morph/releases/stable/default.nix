{ inputs, lib, self,... }:

# Declaration for STABLE release of NixOS for MORPH

let
	inherit (lib) mkForce;
in {
	flake.nixosConfigurations."nixos-morph-stable" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = mkForce false; # Forbid proprietary code
			config.nvidia.acceptLicense = mkForce false; # Nvidia, Fuck You!
		};

		modules = [
			self.nixosModules."nixos-morph"

			{
				nix.nixPath = [
					"nixpkgs=${self.inputs.nixpkgs}"
				];

				nix.registry = {
					nixpkgs = { flake = self.inputs.nixpkgs; };
				};
			}

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default

			# An Anime Game
			self.inputs.aagl.nixosModules.default {
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

	# Task to perform installation of morph in NixOS distribution, stable release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-morph-stable-install = pkgs.writeShellApplication {
				name = "nixos-morph-stable-install";
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
				text = builtins.readFile ./morph-nixos-stable-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-morph-stable-install.program = self'.packages.nixos-morph-stable-install;
	};
}
