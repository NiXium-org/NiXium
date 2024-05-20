{ config, lib, pkgs, crossPkgs, fetchFromGitHub, ... }:

# Custom kernel management for OLIMEX Teres-I

# Upon loading of this file it should enable CCache for the kernel package and built it with the set options

# Ref. https://github.com/lopsided98/nixos-config/blob/6c4a647c5e2642c615bb8b85d425e197693dbcb8/machines/omnitech/default.nix#L47

let
	inherit (lib) mkIf mkDefault;
in {
	system.requiredKernelConfig = mkDefault [];

	boot.kernelModules = mkDefault [];
	boot.extraModulePackages = mkDefault [];

	boot.kernelPackages = let
		linux_teres_pkg = { fetchFromGitHub, buildLinux, ... } @ args:

			buildLinux (args // rec {
				version = "6.9.0";
				modDirVersion = version;

				# Kreyren's Fork
				# src = fetchFromGitHub {
				# 	owner = "Kreyren";
				# 	repo = "linux";
				# 	rev = "7a9ed72485a4c6e2be3943c82013fdaf268186e4";
				# 	hash = "sha256-rYv/9ERN7TNUxb5WnjMy0LTHqTbrIwmp3nIDbvXlkgQ=";
				# };

				# Megi's pp-6.9.0 kernel -- Fails to build
				# src = fetchFromGitHub {
				# 	owner = "Kreyren";
				# 	repo = "linux";
				# 	rev = "133ac821f592bc7255cd3e031ea7416f1b3b2438";
				# 	hash = "sha256-dXdVbV0nzaN1gmwW6B845L41aVFeQqII4myqbxGXAY8=";
				# };

				kernelPatches = [];

				# extraConfig = ''
				# 	INTEL_SGX y
				# '';

				extraMeta.branch = "6.9.0";
			} // (args.argsOverride or {}));
		linux_teres = crossPkgs.callPackage linux_teres_pkg{};
	in
		pkgs.recurseIntoAttrs (crossPkgs.linuxPackagesFor linux_teres);

	nixpkgs.overlays = [
		# FIXME-UPSTREAM(Krey): To avoid failure due to missing root module 'ahci' which is not present on aarch64 (workarounding a nix bug), or is it needed?
		(final: super: {
			makeModulesClosure = x:
				super.makeModulesClosure (x // { allowMissing = true; });
		})

		# CCache
		# FIXME(Krey): Implement CCache for buildLinux
		# (mkIf config.programs.ccache.enable (self: super: {
		# 	linuxManualConfig = super.linuxManualConfig.override { stdenv = super.ccacheStdenv; };
		# }))
	];
}
