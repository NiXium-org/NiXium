{
	flake.nixosModules.security = ./security.nix;
	flake.nixosModules.security-nvidia = ./nvidia.nix;
	flake.nixosModules.security-sudo = ./sudo.nix;
}
