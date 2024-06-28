{
	flake.nixosModules.system-security = ./security.nix;
	flake.nixosModules.system-security-nvidia = ./nvidia.nix;
}
