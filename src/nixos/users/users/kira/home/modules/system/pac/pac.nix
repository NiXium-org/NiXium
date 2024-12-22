{ ... }:

# Proxy Automatic Configuration Management

{
	home.file."proxy.pac" = {
		target = ".config/proxy.pac";
		source = ./kira-pac.es;
	};
}
