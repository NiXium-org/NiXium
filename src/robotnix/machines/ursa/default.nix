{ self, inputs, ... }:

{
	flake.robotnixConfigurations."robotnix-ursa-lineageos" = inputs.robotnix.lib.robotnixSystem {
		device = "equuleus";
		flavor = "lineageos";

		# signing.enable = true;
		# signing.keyStorePath = "/var/secrets/android-keys"; # A _string_ of the path for the key store.

		ccache.enable = true;
	};

	perSystem = { system, pkgs, inputs', self', ... }: {
		packages."robotnix-ursa-lineageos" = self.robotnixConfigurations."robotnix-ursa-lineageos".img;
	};
}
