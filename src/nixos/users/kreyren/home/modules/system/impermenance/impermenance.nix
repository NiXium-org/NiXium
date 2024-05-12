{ ... }:

{
	home.persistence."/persistent/home/kreyren" = {
		directories = [
			# "Downloads"
			# "Music"
			# "Pictures"
			# "Documents"
			# "Videos"
			# "VirtualBox VMs"
			# ".gnupg"
			".ssh"
			# ".nixops"
			".local/share/keyrings"
			# ".local/share/direnv"
		];
		# files = [
		#   ".screenrc"
		# ];
		# allowOther = true;
	};
}
