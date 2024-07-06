{ config, ... }:

{
	programs.git = {
		enable = true; # Should be present everywhere
		# TODO(Krey->Tanvir): Add your things here
		# userName = "Jacob Hrbek";
		# userEmail = "kreyren@fsfe.org";
		# signing.key = "D0501F7980EA70D192C03A52667F0DAFAF09BA2B";
		# NOTE(Krey): Temporary disabled due to https://github.com/NixOS/nixpkgs/issues/35464#issuecomment-2134233517
		signing.signByDefault = false;

		delta = {
			enable = config.programs.git.enable;
			# Configuration: https://dandavison.github.io/delta/usage.html
			options = {
				line-numbers = true;
				whitespace-error-style = "22 reverse";
				side-by-side = true;

				features = "decorations";
				decorations = {
					commit-decoration-style = "bold yellow box ul";
					file-decoration-style = "none";
					file-style = "bold yellow ul";
				};
			};
		};
	};
}
