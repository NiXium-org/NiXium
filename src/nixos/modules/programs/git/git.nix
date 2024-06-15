{ lib, config, pkgs, ... }:

# System git configuration

{
	# NiXium dependency needed to manage systems
	environment.systemPackages = [ pkgs.git ]; # Install Git On All Systems
}
