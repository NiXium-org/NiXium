{ config, self, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kreyren = {
			home-manager.users.kreyren = {
				# These modules are used by default on all systems used by KREYREN user
				imports = [
					self.inputs.arkenfox.hmModules.default
					self.inputs.ragenix.homeManagerModules.default
					self.inputs.impermanence.nixosModules.home-manager.impermanence

					homeManagerModules.default # Include NiXium Home Modules

					./home.nix

					# FIXME-QA(Krey): Expected to be just `homeManagerModules.editors-kreyren` same for all others..
					homeManagerModules.editors-vim-kreyren
					homeManagerModules.editors-vscode-kreyren

					#homeManagerModules.prompts-kreyren
					homeManagerModules.prompts-starship-kreyren

					#homeManagerModules.scripts-kreyren
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

					homeManagerModules.vpn-protonvpn-kreyren

					# homeManagerModules.kreyren.web-browsers.default
					homeManagerModules.web-browsers-firefox-kreyren

					# TODO(Krey): Only do this in GNOME UI
					# GNOME extensions
					# homeManagerModules.gext-custom-accent-colors-kreyren
					# homeManagerModules.gext-shortcuts-kreyren
				];
			};
		};

	imports = [
		./machines
		./modules
	];
}
