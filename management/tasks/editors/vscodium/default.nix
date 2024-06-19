{ ... }:

{
	perSystem = { inputs', ... }: {
		mission-control.scripts = {
			vscodium = {
				description = "Open repository-standardized VSCodium version with configuration";
				category = "Integrated Development Environments";
				exec = ''
					${inputs'.nixpkgs.legacyPackages.vscodium}/bin/codium "$FLAKE_ROOT/default.code-workspace"
				'';
			};
		};
	};
}
