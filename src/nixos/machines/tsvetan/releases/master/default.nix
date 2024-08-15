{ self, lib, inputs, ... }:

# Declaration for STABLE release of NixOS for TSVETAN

let
	inherit (lib) mkForce;
	inherit (builtins) readFile;
in {
	flake.nixosConfigurations."nixos-tsvetan-master" = self.inputs.nixpkgs.lib.nixosSystem {
		system = "aarch64-linux";

		pkgs = import inputs.nixpkgs-master {
			system = "aarch64-linux";
			config.allowUnfree = true;
		};

		modules = [
			self.nixosModules."nixos-tsvetan"

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.sops.nixosModules.sops
			self.inputs.hm.nixosModules.home-manager
			self.inputs.disko.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default
			self.inputs.nixos-generators.nixosModules.all-formats
		];

		specialArgs = {
			inherit self;

			# Priciple args
			stable = import inputs.nixpkgs {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			unstable = import inputs.nixpkgs-unstable {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			master = import inputs.nixpkgs-master {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging = import inputs.nixpkgs-staging {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};

			staging-next = import inputs.nixpkgs-staging-next {
				system = "aarch64-linux";
				config.allowUnfree = mkForce false; # Forbid proprietary code
			};
		};
	};

	# Task to perform installation of TSVETAN in NixOS distribution
	perSystem = { system, pkgs, inputs', self', ... }: {
		# Install
			packages.nixos-tsvetan-master-install = pkgs.writeShellApplication {
				name = "nixos-tsvetan-master-install";
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
					systemDevice = self.nixosConfigurations.nixos-tsvetan-master.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-tsvetan-master.config.disko.devices.disk.system.device;

					secretTsvetanPasswordPath = self.nixosConfigurations.nixos-tsvetan-master.config.age.secrets.tsvetan-disks-password.file;

					secretTsvetanKeyPath = self.nixosConfigurations.nixos-tsvetan-master.config.age.secrets.tsvetan-ssh-ed25519-private.file;
				};
				text = readFile ./tsvetan-nixos-master-install.sh;
			};

			# Declare for `nix run`
			apps.nixos-tsvetan-master-install.program = self'.packages.nixos-tsvetan-stable-install;

		# Hijack
			packages.nixos-tsvetan-master-hijack = pkgs.writeShellApplication {
				name = "nixos-tsvetan-master-hijack";
				bashOptions = [ "errexit" "xtrace" ];
				runtimeInputs = [
					inputs'.nixos-anywhere.packages.nixos-anywhere # nixos-anywhere
					inputs'.disko.packages.disko-install # disko-install
					pkgs.age # age
					pkgs.nixos-install-tools # nixos-install
					pkgs.gawk # awk
				];
				runtimeEnv = {
					systemDevice = self.nixosConfigurations.nixos-tsvetan-master.config.disko.devices.disk.system.device;

					systemDeviceBlock = self.nixosConfigurations.nixos-tsvetan-master.config.disko.devices.disk.system.device;

					secretTsvetanPasswordPath = self.nixosConfigurations.nixos-tsvetan-master.config.age.secrets.tsvetan-disks-password.file;

					secretTsvetanKeyPath = self.nixosConfigurations.nixos-tsvetan-master.config.age.secrets.tsvetan-ssh-ed25519-private.file;
				};
				text = readFile ./tsvetan-nixos-master-hijack.sh;
			};

			# Declare for `nix run`
				apps.nixos-tsvetan-master-hijack.program = self'.packages.nixos-tsvetan-master-hijack;
	};
}
