{ lib, ... }:

let
	inherit (lib) mkForce;
in {
	# We are using pubkeys for the whole infra as they can't be bruteforced and are more functional
	services.openssh.settings.PasswordAuthentication = mkForce false; # Prohibit password auth
}
