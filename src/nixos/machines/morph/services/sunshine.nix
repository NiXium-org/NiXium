{ self, pkgs, config, lib, aagl, ... }:

# MORPH-specific configuration of Sunshine

let
	inherit (lib) mkIf;
in mkIf config.services.sunshine.enable {
	services.sunshine.capSysAdmin = true; # Assign CAP_SYS_ADMIN for DRM/KMS screen capture

	services.sunshine.openFirewall = true; # Open Firewall for local network

	networking.firewall = {
		allowedUDPPorts = [ 47990 ];
		allowedTCPPorts = [ 47990 ];
	};

	# Declare the expected applications
	services.sunshine.applications = {
		apps = [
			{
				name = "Desktop";
				image-path =  "desktop.png";
			}
			{
				name = "Genshin Impact";
				image-path = "desktop.png";
				cmd = "${self.inputs.aagl.packages.x86_64-linux.anime-game-launcher}/bin/anime-game-launcher";
			}
		];
	};

	# User used for the session
	users.users.sunshine = {
		description = "A Sunshine User";
		# uid = 1000;
		isNormalUser = true;
		createHome = true;
		extraGroups = [
			"video"
		];
		packages = [
			self.inputs.aagl.packages.x86_64-linux.anime-game-launcher
		];
	};

	services.tor.relay.onionServices."sunshine".map = mkIf config.services.tor.enable [{ port = 80; target = { port = 47990; }; }]; # Provide the admin panel over onions to make it accessible

	services.displayManager.autoLogin.enable = true;
	services.displayManager.autoLogin.user = "sunshine";

	networking.interfaces.enp6s0.wakeOnLan.enable = true;

	# Impermanence
	environment.persistence."/nix/persist/system".directories = mkIf config.boot.impermanence.enable [
		"/home/sunshine/.local/share/anime-game-launcher"
	];
}
