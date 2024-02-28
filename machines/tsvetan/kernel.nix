{ config, lib, pkgs, crossPkgs, ... }:

# Custom kernel management for OLIMEX Teres-I

# Upon loading of this file it should enable CCache for the kernel package and built it with the set options

# Ref. https://github.com/lopsided98/nixos-config/blob/6c4a647c5e2642c615bb8b85d425e197693dbcb8/machines/omnitech/default.nix#L47

let
	inherit (lib) mkIf mkForce;
in {
	# NOTE(Krey): Whats this?
	system.requiredKernelConfig = mkForce [];

	boot.kernelPackages = pkgs.linuxPackagesFor
		(let
			baseKernel = crossPkgs.linux_testing;
		in
			pkgs.linuxManualConfig {
				inherit (baseKernel) src modDirVersion;
				version = "${baseKernel.version}-teres_i";
				kernelPatches = [
					{
						name = "work-patch";
						patch = ./work.patch;
					}
					{
						name = "anx6345-hotfix";
						patch = ./anx6345-hotfix.patch;
					}
				];
				configfile = ./tinykernel.config;
				allowImportFromDerivation = true;
				# extraMakeFlags = [ "yes2modconfig" "dtbs" ]; # Rebuild dtbs and convert on modules
			}
		);

	nixpkgs.overlays = [
		# FIXME-UPSTREAM(Krey): To avoid failure due to missing root module 'ahci' which is not present on aarch64 (workarounding a nix bug), or is it needed?
		(final: super: {
			makeModulesClosure = x:
				super.makeModulesClosure (x // { allowMissing = true; });
		})

		# CCache
		(mkIf config.programs.ccache.enable (self: super: {
			linuxManualConfig = super.linuxManualConfig.override { stdenv = super.ccacheStdenv; };
		}))
	];
}
