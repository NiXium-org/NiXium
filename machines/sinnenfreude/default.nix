{ self, inputs, homeImports, ... }:

# Flake management of SINNENFREUDE system

{
	# FIXME-QA(Krey): I want to get rid of the `system = "x86_64-linux";` and `pkgs` declaration so that it takes it from the config e.g. `nixpkgs.platform`, but dunno how
	flake.nixosConfigurations."sinnenfreude" = inputs.nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";

		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			# FIXME(Krey): Do Nouveau
			config.nvidia.acceptLicense = true; # Fuck You Nvidia, I am forced into this
		};

		modules = [
			self.nixosModules.default

			# Principles
			self.inputs.ragenix.nixosModules.default
			self.inputs.home-manager-nixpkgs.nixosModules.home-manager
			# self.disko-nixpkgs.nixosModules.disko
			self.inputs.lanzaboote.nixosModules.lanzaboote
			self.inputs.impermanence.nixosModules.impermanence
			self.inputs.arkenfox.hmModules.default

			# Users
			self.nixosModules.users-kreyren # Add KREYREN user
			{
				home-manager.users.raptor.home.stateVersion = "23.11";
				home-manager.users.raptor.imports = [
					#self.homeManagerModules.kreyren.default
					#self.homeManagerConfigurations."kreyren@sinnenfreude"

					../../nixos/users/kreyren/home/home.nix
					../../nixos/users/kreyren/home/machines/sinnenfreude/home-configuration.nix
					../../nixos/users/kreyren/home/modules/editors/vim/vim.nix
					../../nixos/users/kreyren/home/modules/editors/vscode/vscode.nix
					../../nixos/users/kreyren/home/modules/editors/vscode/vscode.nix
					../../nixos/users/kreyren/home/modules/prompts/starship/starship.nix
					../../nixos/users/kreyren/home/modules/shells/bash/bash.nix
					../../nixos/users/kreyren/home/modules/shells/nushell/nushell.nix
					../../nixos/users/kreyren/home/modules/shells/nushell/nushell.nix
					../../nixos/users/kreyren/home/modules/system/dconf/dconf.nix
					../../nixos/users/kreyren/home/modules/system/gtk/gtk.nix
					../../nixos/users/kreyren/home/modules/terminal-emulators/alacritty/alacritty.nix
					../../nixos/users/kreyren/home/modules/terminal-emulators/alacritty/alacritty.nix
					../../nixos/users/kreyren/home/modules/tools/direnv/direnv.nix
					../../nixos/users/kreyren/home/modules/tools/git/git.nix
					../../nixos/users/kreyren/home/modules/tools/gpg-agent/gpg-agent.nix
					#../../nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix
					../../nixos/users/kreyren/home/modules/web-browsers/librewolf/librewolf.nix
				];
			}

			./configuration.nix
			./hardware-configuration.nix
			./impermenance.nix
			# ./disko.nix # FIXME(Krey): I don't know how to implement that yet
		];

		# FIXME-QA(Krey): This needs better management
		specialArgs = {
			unstable = import inputs.nixpkgs-unstable {
				system = "x86_64-linux";
				config.allowUnfree = true;
			};
		};
	};
}
