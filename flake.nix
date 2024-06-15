{
	description = "Kreyren's Infrastructure Management With NiXium";

	inputs = {
		# Release inputs
			nixpkgs-master.url = "github:nixos/nixpkgs/master";
			nixpkgs-staging-next.url = "github:nixos/nixpkgs/staging-next";
			nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
			nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

			# NOTE(Krey): Flakehub is returning 23.11 for some reason atm
			nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
			# nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz"; # Management to always use the latest stable release
				# nixpkgs.url = "git+file:///home/kreyren/src/nixpkgs";

			nixpkgs-23_05.url = "github:nixos/nixpkgs/nixos-23.05";
			nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11";
			nixpkgs-24_05.url = "github:nixos/nixpkgs/nixos-24.05";

			nixpkgs-kreyren.url = "github:kreyren/nixpkgs/central";

		# Principle inputs
			nixos-hardware.url = "github:NixOS/nixos-hardware";
			nixos-flake.url = "github:srid/nixos-flake";
			# nur.url = "github:nix-community/NUR/master";
			#impermanence.url = "github:nix-community/impermanence";
			impermanence.url = "github:kreyren/impermanence"; # Use a fork to manage https://github.com/nix-community/impermanence/issues/167
			flake-parts.url = "github:hercules-ci/flake-parts";
			mission-control.url = "github:Platonic-Systems/mission-control";
			flake-root.url = "github:srid/flake-root";
			lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0"; # MAINTAIN(Krey): has to be kept up to date -- https://github.com/nix-community/lanzaboote/issues/343
			arkenfox.url = "github:dwarfmaster/arkenfox-nixos";

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		rust-overlay.url = "github:oxalica/rust-overlay";

		# SOPS
			sops = {
				url = "github:Mic92/sops-nix";
				inputs.nixpkgs.follows = "nixpkgs";
			};
			sops-unstable = {
				url = "github:Mic92/sops-nix";
				inputs.nixpkgs.follows = "nixpkgs";
			};

		# Ragenix
			ragenix = {
				url = "github:yaxitech/ragenix";
				inputs.nixpkgs.follows = "nixpkgs";
			};
			ragenix-unstable = {
				url = "github:yaxitech/ragenix";
				inputs.nixpkgs.follows = "nixpkgs-unstable";
			};

		# DISKO
			disko = {
				url = "github:nix-community/disko";
				inputs.nixpkgs.follows = "nixpkgs";
			};
			disko-unstable = {
				url = "github:nix-community/disko";
				inputs.nixpkgs.follows = "nixpkgs-unstable";
			};

		# AAGL
			# FIXME(Krey): Lacks 24.05 release atm --
			aagl = {
				url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";
				inputs.nixpkgs.follows = "nixpkgs-24_05";
			};

			aagl-24_05 = {
				url = "github:ezKEa/aagl-gtk-on-nix/release-24.05";
				inputs.nixpkgs.follows = "nixpkgs-24_05";
			};
			aagl-23_11 = {
				url = "github:ezKEa/aagl-gtk-on-nix/release-23.11";
				inputs.nixpkgs.follows = "nixpkgs-23_11";
			};

			aagl-unstable = {
				url = "github:ezKEa/aagl-gtk-on-nix";
			};

		# Home-Manager
			hm = {
				url = "github:nix-community/home-manager/release-24.05";
				inputs.nixpkgs.follows = "nixpkgs";
			};

			hm-24_05 = {
				url = "github:nix-community/home-manager/release-24.05";
				inputs.nixpkgs.follows = "nixpkgs-24_05";
			};
			hm-23_11 = {
				url = "github:nix-community/home-manager/release-23.11";
				inputs.nixpkgs.follows = "nixpkgs-23_11";
			};

			hm-unstable = {
				url = "github:nix-community/home-manager/master";
				inputs.nixpkgs.follows = "nixpkgs-unstable";
			};

		# Emacs
		## TODO(Krey): Implement?
		# emacs-overlay.url = "github:nix-community/emacs-overlay";
		# nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";

		# For T-Head Kernel and stuff
		nixos-licheepi4a.url = "github:ryan4yin/nixos-licheepi4a";

		nixos-generators = {
			url = "github:nix-community/nixos-generators";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ { self, ... }:
		inputs.flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				./src/nixos # Imports NixOS related things
				./lib # Implement libs

				inputs.flake-root.flakeModule
				inputs.mission-control.flakeModule
			];

			systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];

			perSystem = { system, config, ... }: {
				# FIXME-QA(Krey): Move this to a separate file somehow?
				# FIXME-QA(Krey): Figure out how to shorten the `inputs.nixpkgs-unstable.legacyPackages.${system}` ?
				## _module.args.nixpkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
				## _module.args.nixpkgs = import inputs.nixpkgs { inherit system; };
				mission-control.scripts = {
					# Editors
					vscodium = {
						description = "VSCodium (Fully Integrated)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs-unstable.legacyPackages.${system}.vscodium}/bin/codium ./default.code-workspace";
					};
					vim = {
						description = "vIM (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.vim}/bin/vim .";
					};
					neovim = {
						description = "Neovim (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.neovim}/bin/nvim .";
					};
					emacs = {
						description = "Emacs (Minimal Integration, fixme)";
						category = "Integrated Editors";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.emacs}/bin/emacs .";
					};
					# NOTE(Krey): Don't do automated code-formatting
					# # Code Formating
					# nixpkgs-fmt = {
					# 	description = "Format Nix Files With The Standard Nixpkgs Formater";
					# 	category = "Code Formating";
					# 	exec = "${inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt}/bin/nixpkgs-fmt .";
					# };
					# alejandra = {
					# 	description = "Format Nix Files With The Uncompromising Nix Code Formatter (Not Recommended)";
					# 	category = "Code Formating";
					# 	exec = "${inputs.nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra .";
					# };

					# Management
					# FIXME-QA(Krey): Move this into a separate files
					"verify" = {
						description = "Verify the system declaration(s)";
						category = "Administration";
						exec = ''
							case "$*" in
								all) # Verify All Systems
									for system in $(find ./src/nixos/machines/* -maxdepth 0 -type d | sed "s#^./src/nixos/machines/##g" | tr '\n' ' '); do
										echo "Checking system: $system"

										if [ ! -f "./src/nixos/machines/$system/default.nix" ]; then
											${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild dry-build --flake ".#$system" --option eval-cache false --show-trace || echo "WARNING: System $system failed evaluation!"
										else
											echo "The configuration of system '$system' not yet declared, skipping.."
										fi
									done
								;;
								"") # Verify Current System
									hostname="$(hostname --short)"
									echo "Checking system: $hostname"
									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild dry-build --flake ".#$hostname" --option eval-cache false --show-trace
								;;
								*) # Verify System By (derivation) Name
									echo "Checking system: $*"
									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild dry-build --flake ".#$*" --option eval-cache false --show-trace
							esac
						'';
					};

					"update" = {
						description = "Update the flake locks";
						category = "Management";
						exec = "nix flake update";
					};

					"deploy" = {
						description = "Deploy the configuration on the current system or all of them";
						category = "Administration";
						exec = ''
							repoDir="$PWD" # Get path to the repository

							case "$*" in
								"")
									for system in $(find ./src/nixos/machines/* -maxdepth 0 -type d | sed "s#^./src/nixos/machines/##g" | tr '\n' ' '); do
										case "$(cat "./src/nixos/machines/$system/status")" in
											"OK")
												echo "Deploying the configuration for system: $system"

												${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "git+file://$repoDir#$system" --target-host "root@$system.systems.nx" --option eval-cache false |& ${inputs.nixpkgs.legacyPackages.${system}.gawk}/bin/awk "{ print \"[$system]\", \$0 }"
											;;
											*) echo "Configuration for system '$system' is not valid, skipping.."
										esac
										sleep 0.5 # Give it some delay
									done
									;;
								*)
									echo "Switching configuration for system: $*"

									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "git+file://$repoDir#$*" --target-host "root@$*.systems.nx" --option eval-cache false
							esac
						'';
					};

					"switch" = {
						description = "Switch the configuration on the current system";
						category = "Administration";
						exec = ''
							repoDir="$PWD" # Get path to the repository

							case "$*" in
								"")
									hostname="$(hostname --short)"
									echo "Switching configuration for system: $hostname"

									${self.inputs.nixpkgs.legacyPackages.${system}.openssh}/bin/ssh root@localhost ${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "git+file:///$repoDir#$hostname" --option eval-cache false
									;;
								*)
									echo "Switching configuration for system: $*"

									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "$repoDir#$*" --target-host "root@$*.systems.nx" --option eval-cache false
							esac
						'';
					};

					"build" = {
						description = "build the configuration without deployment";
						category = "Administration";
						exec = ''
							repoDir="$PWD" # Get path to the repository

							case "$*" in
								"all")
									for system in $(find ./src/nixos/machines/* -maxdepth 0 -type d | sed "s#^./src/nixos/machines/##g" | tr '\n' ' '); do
										case "$(cat "./src/nixos/machines/$system/status")" in
											"OK")
												echo "Building the configuration for system: $system"

												${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild build --flake "$repoDir#$system" --target-host "root@$system.systems.nx" --option eval-cache false
											;;
											*) echo "Configuration for system '$system' is not valid, skipping.."
										esac
									done
									;;
								"")
									system="$(hostname --short)"
									echo "Building the configuration for system: $system"

									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild build --flake "$repoDir#$system" --target-host "root@$system.systems.nx" --option eval-cache false
									;;
								*)
									echo "Switching configuration for system: $*"

									${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild build --flake "$repoDir#$*" --target-host "root@$*.systems.nx" --option eval-cache false
							esac
						'';
					};

					"rekey" = {
						description = "Refresh all secret files";
						category = "Management";
						exec = ''
							# NixOS
							RULES=./src/nixos/secrets.nix ragenix -r
						'';
					};
				};
				devShells.default = inputs.nixpkgs.legacyPackages.${system}.mkShell {
					name = "NiXium-devshell";
					nativeBuildInputs = [
						inputs.nixpkgs.legacyPackages.${system}.bashInteractive # For terminal
						inputs.nixpkgs.legacyPackages.${system}.nil # Needed for linting
						inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt # Nixpkgs formatter
						inputs.nixpkgs.legacyPackages.${system}.git # Working with the codebase

						inputs.ragenix.packages.${system}.default # To manage secrets
						inputs.nixpkgs.legacyPackages.${system}.age # Managing age files

						inputs.nixpkgs.legacyPackages.${system}.sops # Secret management
						inputs.nixpkgs.legacyPackages.${system}.sbctl # To set up secureboot
						inputs.nixpkgs.legacyPackages.${system}.fira-code # For liquratures in code editors

						inputs.nixos-generators.packages.${system}.nixos-generate

						inputs.disko.packages.${system}.disko-install
						inputs.disko.packages.${system}.disko
					];
					inputsFrom = [ config.mission-control.devShell ];
					# Environmental Variables
					#RULES = "./secrets/secrets.nix"; # For ragenix to know where secrets are
				};

				formatter = inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
			};
		};
}
