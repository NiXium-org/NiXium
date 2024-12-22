{ self, moduleWithSystem, config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kira = moduleWithSystem (
		perSystem@{ system }:
		{ ... }: {
				home-manager.users.kira = {
					imports = [
						self.inputs.arkenfox.hmModules.default
						self.inputs.ragenix.homeManagerModules.default
						self.inputs.impermanence.nixosModules.home-manager.impermanence

						homeManagerModules.default # Include NiXium Home Modules

						./home.nix

						# FIXME-QA(Krey): Expected to be just `homeManagerModules.editors-kira` same for all others..
						homeManagerModules.editors-vim-kira
						homeManagerModules.editors-vscode-kira

						#homeManagerModules.prompts-kira
						homeManagerModules.prompts-starship-kira

						# homeManagerModules.kira.shells.default
						homeManagerModules.shells-bash-kira
						homeManagerModules.shells-nushell-kira

						# homeManagerModules.kira.system.default
						homeManagerModules.system-flatpak-kira
						homeManagerModules.system-gtk-kira
						homeManagerModules.system-impermanence-kira
						homeManagerModules.system-pac-kira

						# homeManagerModules.kira.terminal-emulators.default
						homeManagerModules.terminal-emulators-alacritty-kira

						# homeManagerModules.kira.tools.default
						homeManagerModules.tools-direnv-kira
						homeManagerModules.tools-git-kira
						homeManagerModules.tools-gpg-agent-kira
						homeManagerModules.tools-ragenix-kira

						homeManagerModules.vpn-protonvpn-kira

						# homeManagerModules.kira.web-browsers.default
						homeManagerModules.web-browsers-firefox-kira
						homeManagerModules.web-browsers-librewolf-kira
					];
				};

				# Include Import Arguments
				# FIXME-MANAGEMENT(Krey): This should be included for all users by default
				home-manager.extraSpecialArgs = {
					inherit self;

					aagl = self.inputs.aagl.packages."${system}";
					unstable = self.inputs.nixpkgs-unstable.legacyPackages."${system}";
					staging-next = self.inputs.nixpkgs-staging-next.legacyPackages."${system}";
					polymc = self.inputs.polymc.packages."${system}";
					firefox-addons = self.inputs.firefox-addons.packages."${system}";
				};
		});

	imports = [
		./machines
		./modules
	];
}
