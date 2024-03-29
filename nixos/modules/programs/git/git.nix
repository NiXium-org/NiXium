{ lib, config, pkgs, ... }:

# System git configuration

# NOTE(Krey): NiXium needs `git` for root escalation through pubkeys

{
	environment.systemPackages = [ pkgs.git ]; # Install clamtk system-wide if clamav is used
}
