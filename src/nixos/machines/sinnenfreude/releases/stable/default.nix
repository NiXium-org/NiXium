{ inputs, self,... }:

# Declaration for STABLE release of NixOS for SINNENFREUDE

{
	flake.nixosConfigurations."nixos-sinnenfreude-stable" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this!
		};

		modules = [
			self.nixosModules."nixos-sinnenfreude"

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

		# FIXME-QA(Krey): Figure out if we can put this into nixos-sinnenfreude module to avoid reusing it for everything else
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

	# Task to perform installation of SINNENFREUDE in NixOS distribution, stable release
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-sinnenfreude-stable-install = pkgs.writeShellApplication {
				name = "nixos-sinnenfreude-stable-install";
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
					systemDevice = self.nixosConfigurations.nixos-sinnenfreude-stable.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-sinnenfreude-stable.config.disko.devices.disk.system.device;

					secretPasswordPath = self.nixosConfigurations.nixos-sinnenfreude-stable.config.age.secrets.sinnenfreude-disks-password.file;

					secretSSHHostKeyPath = self.nixosConfigurations.nixos-sinnenfreude-stable.config.age.secrets.sinnenfreude-ssh-ed25519-private.file;
				};
				text = builtins.readFile ./sinnenfreude-nixos-stable-install.sh;
			};

		# Declare for `nix run`
		apps.nixos-sinnenfreude-stable-install.program = self'.packages.nixos-sinnenfreude-stable-install;
	};
}
