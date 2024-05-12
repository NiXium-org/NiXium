{
	description = "Kreyren's Infrastructure Management With NiXium";

	# FIXME-QA(Krey): This file needs re-organization

	inputs = {
		# Release inputs
		nixpkgs-master.url = "github:nixos/nixpkgs/master";
		nixpkgs-staging-next.url = "github:nixos/nixpkgs/staging-next";
		nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz"; # Management to always use the latest stable release
			# nixpkgs.url = "git+file:///home/raptor/src/nixpkgs";

		nixpkgs-23_05.url = "github:nixos/nixpkgs/nixos-23.05";
		nixpkgs-23_11.url = "github:nixos/nixpkgs/nixos-23.11";

		# Principle inputs
		nixos-hardware.url = "github:NixOS/nixos-hardware";
		nixos-flake.url = "github:srid/nixos-flake";
		# nur.url = "github:nix-community/NUR/master";
		impermanence.url = "github:nix-community/impermanence";
		flake-parts.url = "github:hercules-ci/flake-parts";
		mission-control.url = "github:Platonic-Systems/mission-control";
		flake-root.url = "github:srid/flake-root";
		lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0"; # MAINTAIN(Krey): has to be kept up to date
		arkenfox.url = "github:dwarfmaster/arkenfox-nixos";

		firefox-addons = {
			url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		ragenix = {
			url = "github:yaxitech/ragenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		ragenix-unstable = {
			url = "github:yaxitech/ragenix";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		disko = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko-unstable = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		aagl = {
			url = "github:ezKEa/aagl-gtk-on-nix/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		aagl-unstable = {
			url = "github:ezKEa/aagl-gtk-on-nix";
		};

		# Home-Manager
		hm = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
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
						category = "Management";
						exec = ''
							case "$*" in
								all) # Verify All Systems
									for system in $(find ./src/nixos/machines/* -type d | sed "s#^./machines/##g" | tr '\n' ' '); do
										echo "Checking system: $system"
										${inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild dry-build --flake ".#$system" --option eval-cache false --show-trace || echo "WARNING: System $system failed evaluation!"
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

					"switch" = {
						description = "Switch the configuration on the current system";
						category = "Management";
						exec = ''
							repoDir="$PWD" # Get path to the repository

							if [ -n "$*" ]; then
								echo "Switching configuration for system: $*"
								${self.inputs.nixpkgs.legacyPackages.${system}.openssh}/bin/ssh root@localhost ${self.inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "$repoDir#$*" --option eval-cache false
							else
								hostname="$(hostname --short)"
								echo "Switching configuration for system: $hostname"
								${self.inputs.nixpkgs.legacyPackages.${system}.openssh}/bin/ssh root@localhost ${self.inputs.nixpkgs.legacyPackages.${system}.nixos-rebuild}/bin/nixos-rebuild switch --flake "$repoDir#$hostname" --option eval-cache false
							fi
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
						inputs.nixpkgs.legacyPackages.${system}.sbctl # To set up secureboot
						inputs.nixpkgs.legacyPackages.${system}.fira-code # For liquratures in code editors
						inputs.nixos-generators.packages.${system}.nixos-generate
					];
					inputsFrom = [ config.mission-control.devShell ];
					# Environmental Variables
					#RULES = "./secrets/secrets.nix"; # For ragenix to know where secrets are
				};

				formatter = inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
			};
		};
}
