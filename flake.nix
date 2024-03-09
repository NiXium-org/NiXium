{
	description = "Kreyren's Infrastructure Management With NiXium";

	inputs = {
		# Release inputs
		nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-23.05";
		nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
		# # nixpkgs.url = "git+file:///home/raptor/src/nixpkgs";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		# nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable";
		nixpkgs-master.url = "github:nixos/nixpkgs/master";
		nixpkgs-staging.url = "github:nixos/nixpkgs/staging";

		# Principle inputs
		nixos-hardware.url = "github:NixOS/nixos-hardware";
		nixos-flake.url = "github:srid/nixos-flake";
		nur.url = "github:nix-community/NUR/master";
		impermanence.url = "github:nix-community/impermanence";
		flake-parts.url = "github:hercules-ci/flake-parts";
		mission-control.url = "github:Platonic-Systems/mission-control";
		flake-root.url = "github:srid/flake-root";
		ragenix.url = "github:yaxitech/ragenix";
		lanzaboote.url = "github:nix-community/lanzaboote/v0.3.0"; # MAINTAIN(Krey): has to be kept up to date
		arkenfox.url = "github:dwarfmaster/arkenfox-nixos";

		disko-nixpkgs = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko-nixpkgs-unstable = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		# Home-Manager
		home-manager = {
			url = "github:nix-community/home-manager/release-23.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		home-manager-nixpkgs-unstable = {
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
				./nixos # Imports NixOS related things
				./machines # Imports machines
				./lib # Implement libs

				inputs.flake-root.flakeModule
				inputs.mission-control.flakeModule
			];

			systems = [ "x86_64-linux" "aarch64-linux" "riscv64-linux" ];

			perSystem = { system, config, ... }: {
				# FIXME-QA(Krey): Move this to  a separate file somehow?
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
					# Code Formating
					nixpkgs-fmt = {
						description = "Format Nix Files With The Standard Nixpkgs Formater";
						category = "Code Formating";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt}/bin/nixpkgs-fmt .";
					};
					alejandra = {
						description = "Format Nix Files With The Uncompromising Nix Code Formatter (Not Recommended)";
						category = "Code Formating";
						exec = "${inputs.nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra .";
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
						inputs.nixpkgs.legacyPackages.${system}.nixUnstable # Test
					];
					inputsFrom = [ config.mission-control.devShell ];
					# Environmental Variables
					#RULES = "./secrets/secrets.nix"; # For ragenix to know where secrets are
				};

				formatter = inputs.nixpkgs.nixpkgs-fmt;
			};
		};
}
