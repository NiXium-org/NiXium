{ ... }:

# Gloobal Management of Nix for all systems

let
	inherit (builtins) toFile;
in {
	nix = {
		# package = pkgs.nixUnstable;
		# nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
		# FIXME(Krey): No fucking idea how to implement this, wasted 8h on it
		# registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
		settings = {
			experimental-features = "nix-command flakes";
			auto-optimise-store = true;
			#system-features = [ "recursive-nix" ];
			# Nullify the registry for purity
			flake-registry = toFile "empty-flake-registry.json"
				''{"flakes":[],"version":2}'';
			trusted-users = [
				"raptor"
			];
		};
		gc = {
			automatic = true;
			dates = "weekly";
			options = "--delete-older-than 14d";
			randomizedDelaySec = toString (60 * 60 * 4); # 4 Hours
		};
# FORMATTING(Krey): Pain.. tabs are not processed correctly
    extraOptions = ''
      builders-use-substitutes = true
      min-free = ${toString (512 * 1024 * 1024)}
      max-free = ${toString (2048 * 1024 * 1024)}
    '';
	};
}
