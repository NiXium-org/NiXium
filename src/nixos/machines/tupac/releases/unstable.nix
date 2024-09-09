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

	# Task to perform installation of TUPC in NixOS distribution
	perSystem = { system, pkgs, inputs', self', ... }: {
		packages.nixos-tupac-unstable-install = pkgs.writeShellApplication {
			name = "nixos-tupac-unstable-install";
			runtimeInputs = [
				inputs'.disko.packages.disko-install
				pkgs.age
			];
			text = ''
				# FIXME-QA(Krey): This should be a runtimeInput
				die() { printf "FATAL: %s\n" "$2"; exit ;}

				[ -f "${self.nixosConfigurations.tupac.config.disko.devices.disk.system.device}" ] || die 1 "Expected device was not found, refusing to install"

				ragenixTempDir="/var/tmp/nixium"
				ragenixIdentity="$HOME/.ssh/id_ed25519"

				[ -d "$ragenixTempDir" ] || sudo mkdir "$ragenixTempDir"
				sudo chown -R "$USER:users" "$ragenixTempDir"
				sudo chmod -R 700 "$ragenixTempDir"

				[ -s "$ragenixTempDir/tupac-disks-password" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tupac-disks-password" "${self.nixosConfigurations.tupac.config.age.secrets.tupac-disks-password.file}"

				[ -s "$ragenixTempDir/tupac-ssh-ed25519-private" ] || age --identity "$ragenixIdentity" --decrypt --output "$ragenixTempDir/tupac-ssh-ed25519-private" "${self.nixosConfigurations.tupac.config.age.secrets.tupac-ssh-ed25519-private.file}"

				sudo disko-install \
					--flake "git+file://$FLAKE_ROOT#tupac" \
					--disk system "$(realpath ${self.nixosConfigurations.tupac.config.disko.devices.disk.system.device})" \
					--extra-files "$ragenixTempDir/tupac-ssh-ed25519-private" /nix/persist/system/etc/ssh/ssh_host_ed25519_key
			'';
		};

		# Declare for `nix run`
		apps.nixos-tupac-unstable-install.program = self'.packages.nixos-tupac-unstable-install;
	};
}
