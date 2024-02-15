{ config, ... }:

let
	inherit (config.flake) homeManagerModules;
in {
	# flake.homeManagerModules.kreyren.default.imports = [
	# 	#homeManagerModules.kreyren.editors.default
	# 	#homeManagerModules.kreyren.prompts.starship
	# 	#homeManagerModules.kreyren.shells.default
	# 	#homeManagerModules.kreyren.system.default
	# 	#homeManagerModules.kreyren.terminal-emulators.alacritty
	# 	#homeManagerModules.kreyren.tools.default
	# 	#homeManagerModules.kreyren.web-browsers.default
	# ];

	imports = [
		./machines
		#./modules
	];
}
