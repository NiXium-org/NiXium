{ config, lib, ...}:

# Security Management of sudo

let
	inherit (lib) mkIf;
in mkIf config.security.sudo.enable {
	security.sudo.extraConfig = "Defaults lecture = never"; # Rollback results in sudo lectures after each reboot
}
