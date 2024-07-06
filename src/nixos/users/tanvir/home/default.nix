{ moduleWithSystem, config, self, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.tanvir = moduleWithSystem (
		perSystem@{ system }:
		{ ... }: {
			home-manager.users.tanvir = {
				# These modules are used by default on all systems
				imports = [
					self.inputs.arkenfox.hmModules.default
					self.inputs.ragenix.homeManagerModules.default
					self.inputs.impermanence.nixosModules.home-manager.impermanence

					./home.nix

					# FIXME(Krey): Broken on impermanent setup after `switch`
					#homeManagerModules.apps-flameshot-tanvir

					# FIXME-QA(Krey): Expected to be just `homeManagerModules.editors-tanvir` same for all others..
					homeManagerModules.editors-vim-tanvir
					homeManagerModules.editors-vscode-tanvir

					#homeManagerModules.prompts-tanvir
					homeManagerModules.prompts-starship-tanvir

					# homeManagerModules.tanvir.shells.default
					homeManagerModules.shells-bash-tanvir
					homeManagerModules.shells-nushell-tanvir

					# homeManagerModules.tanvir.system.default
					homeManagerModules.system-dconf-tanvir
					homeManagerModules.system-gtk-tanvir
					homeManagerModules.system-impermanence-tanvir
					homeManagerModules.system-nix-tanvir

					# homeManagerModules.tanvir.terminal-emulators.default
					homeManagerModules.terminal-emulators-alacritty-tanvir

					# homeManagerModules.tanvir.tools.default
					homeManagerModules.tools-direnv-tanvir
					homeManagerModules.tools-git-tanvir
					homeManagerModules.tools-gpg-agent-tanvir

					# homeManagerModules.tanvir.web-browsers.default
					homeManagerModules.web-browsers-firefox-tanvir
					homeManagerModules.web-browsers-librewolf-tanvir

					# GNOME extensions
					homeManagerModules.gext-custom-accent-colors-tanvir
					homeManagerModules.gext-shortcuts-tanvir
				];
			};

			home-manager.extraSpecialArgs = {
				inherit self;
				aagl = self.inputs.aagl.packages."${system}";
				unstable = self.inputs.nixpkgs-unstable.legacyPackages."${system}";
				staging-next = self.inputs.nixpkgs-staging-next.legacyPackages."${system}";
				firefox-addons = self.inputs.firefox-addons.packages."${system}";
			};
		}
	);

	imports = [
		./machines
		./modules
	];
}
