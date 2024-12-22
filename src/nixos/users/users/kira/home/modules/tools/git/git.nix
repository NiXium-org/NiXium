{ config, ... }:

{
	programs.git = {
		enable = true; # Should be present everywhere
		userName = "Kiroshi";
		# userEmail = "user@fsfe.org";
		# signing.key = "...";
		signing.signByDefault = true;

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

		# SECURITY(Krey): Contains email password!
		extraConfig = {
			sendemail = {
				smtpServer = "127.0.0.1";
				# smtpUser = "kreyren@proton.me";
				# smtpPass = "REDACTED"; # FIXME-SECURITY(Krey): Set up ragenix for this
				smtpEncryption = "ssl";
				smtpServerport = 1025;
				# Required due to the use of protonmail
				smtpSslCertPath = "";
			};
		};
	};
}
