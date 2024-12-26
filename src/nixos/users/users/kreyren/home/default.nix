{ config, self, moduleWithSystem, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kreyren = moduleWithSystem (
			perSystem@{ system }:
			{ ... }: {
				home-manager.users.kreyren = {
					imports = [
						self.inputs.arkenfox.hmModules.default
						self.inputs.ragenix.homeManagerModules.default
						self.inputs.impermanence.nixosModules.home-manager.impermanence

						homeManagerModules.default # Include NiXium Home Modules

						./home.nix

						# FIXME-QA(Krey): Expected to be just `homeManagerModules.apps-kreyren` same for all others..
						homeManagerModules.apps-bottles-kreyren

						# homeManagerModules.editors-kreyren
						homeManagerModules.editors-vim-kreyren
						homeManagerModules.editors-vscode-kreyren

						#homeManagerModules.prompts-kreyren
						homeManagerModules.prompts-starship-kreyren

						#homeManagerModules.scripts-kreyren
						homeManagerModules.scripts-ssh-ignucius-kreyren
						homeManagerModules.scripts-ssh-morph-kreyren
						homeManagerModules.scripts-ssh-mracek-kreyren
						homeManagerModules.scripts-ssh-sinnenfreude-kreyren
						homeManagerModules.scripts-wake-morph-kreyren

						# homeManagerModules.kreyren.shells.default
						homeManagerModules.shells-bash-kreyren
						homeManagerModules.shells-nushell-kreyren

						# homeManagerModules.kreyren.system.default
						homeManagerModules.system-flatpak-kreyren
						homeManagerModules.system-gtk-kreyren
						homeManagerModules.system-impermanence-kreyren
						homeManagerModules.system-pac-kreyren

						# homeManagerModules.kreyren.terminal-emulators.default
						homeManagerModules.terminal-emulators-alacritty-kreyren

						# homeManagerModules.kreyren.tools.default
						homeManagerModules.tools-git-kreyren
						homeManagerModules.tools-gpg-agent-kreyren
						homeManagerModules.tools-ragenix-kreyren

						homeManagerModules.ui-gnome-kreyren
						homeManagerModules.ui-gnome-theme-generic-kreyren # Use Generic GNOME Theme

						# homeManagerModules.vpn-kreyren
						homeManagerModules.vpn-protonvpn-kreyren

						# homeManagerModules.kreyren.web-browsers.default
						homeManagerModules.web-browsers-firefox-kreyren
					];
				};

				# Include Import Arguments
				# FIXME-MANAGEMENT(Krey): This should be included for all users by default
				home-manager.extraSpecialArgs = {
					inherit self;

					staging-next = self.inputs.nixpkgs-staging-next.legacyPackages."${system}";
					unstable = self.inputs.nixpkgs-unstable.legacyPackages."${system}";
					stable = self.inputs.nixpkgs.legacyPackages."${system}";
					nixpkgs-24_05 = self.inputs.nixpkgs-24_05.legacyPackages."${system}";

					aagl = self.inputs.aagl.packages."${system}";
					polymc = self.inputs.polymc.packages."${system}";
					firefox-addons = self.inputs.firefox-addons.packages."${system}";
				};
			});

	imports = [
		./machines
		./modules
	];
}
