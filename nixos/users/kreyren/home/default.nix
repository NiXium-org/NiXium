{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	flake.homeManagerModules.kreyren.imports = [
		./home.nix

		# ../../nixos/users/kreyren/home/machines/sinnenfreude/home-configuration.nix
		# ../../nixos/users/kreyren/home/modules/editors/vim/vim.nix
		# ../../nixos/users/kreyren/home/modules/editors/vscode/vscode.nix
		# ../../nixos/users/kreyren/home/modules/editors/vscode/vscode.nix
		# ../../nixos/users/kreyren/home/modules/prompts/starship/starship.nix
		# ../../nixos/users/kreyren/home/modules/shells/bash/bash.nix
		# ../../nixos/users/kreyren/home/modules/shells/nushell/nushell.nix
		# ../../nixos/users/kreyren/home/modules/shells/nushell/nushell.nix
		# ../../nixos/users/kreyren/home/modules/system/dconf/dconf.nix
		# ../../nixos/users/kreyren/home/modules/system/gtk/gtk.nix
		# ../../nixos/users/kreyren/home/modules/terminal-emulators/alacritty/alacritty.nix
		# ../../nixos/users/kreyren/home/modules/terminal-emulators/alacritty/alacritty.nix
		# ../../nixos/users/kreyren/home/modules/tools/direnv/direnv.nix
		# ../../nixos/users/kreyren/home/modules/tools/git/git.nix
		# ../../nixos/users/kreyren/home/modules/tools/gpg-agent/gpg-agent.nix
		# #../../nixos/users/kreyren/home/modules/web-browsers/firefox/firefox.nix
		# ../../nixos/users/kreyren/home/modules/web-browsers/librewolf/librewolf.nix

		# homeManagerModules.editors-kreyren
		#../../../../nixos/users/kreyren/home/modules/editors/vim/vim.nix
		# homeManagerModules.kreyren.prompts.default
		# homeManagerModules.kreyren.shells.default
		# homeManagerModules.kreyren.system.default
		# homeManagerModules.kreyren.terminal-emulators.alacritty
		# homeManagerModules.kreyren.tools.default
		# homeManagerModules.kreyren.web-browsers.default
	];

	imports = [
		./machines
		./modules
	];
}
