{ lib, ... }:

# DNSCrypt configuration

# Inspired-by: https://github.com/JayRovacsek/nix-config/blob/3891046a137c8a3463f9250f22c141e9dfd70494/modules/stubby/default.nix#L6

let
	inherit (lib) version;

	utilisedPort = 8053;

	libredns = {
		address_data = "116.202.176.26";
		tls_auth_name = "dot.libredns.gr";
		tls_port = 853;
	};

	ahaDnsNl = {
		address_data = "5.2.75.75";
		tls_auth_name = "dot.nl.ahadns.net";
		tls_port = 853;
	};

	# ahaDnsLa = {
	# 	address_data = "45.67.219.208";
	# 	tls_auth_name = "dot.la.ahadns.net";
	# 	tls_port = 853;
	# };

	quadNine = {
		address_data = "9.9.9.9";
		tls_auth_name = "dns.quad9.net";
		tls_port = 853;
	};

	appliedPrivacy = {
		address_data = "146.255.56.98";
		tls_auth_name = "dot1.applied-privacy.net";
		tls_port = 853;
	};

	# loggingOptions = if version < "22.11" then
	# 	{ }
	# else if version < "23.05" then {
	# 	debugLogging = true;
	# } else {
	# 	logLevel = "info";
	# };
in {
	networking = {
		nameservers = [ "127.0.0.1" "::1" ];
		# If using dhcpcd:
		dhcpcd.extraConfig = "nohook resolv.conf";
		# If using NetworkManager:
		networkmanager.dns = "none";
	};

	# Make sure you don't have services.resolved.enable on

	services.stubby = {
		# enable = true;
		settings = {
			upstream_recursive_servers = [
				libredns
				# ahaDnsLa # NOTE-PRIVACY(Krey): I don't trust the US for privacy
				ahaDnsNl
				quadNine
				appliedPrivacy
			];
			edns_client_subnet_private = 1;
			round_robin_upstreams = 1;
			idle_timeout = 10000;
			listen_addresses = [ "0.0.0.0@${toString utilisedPort}" ];
			tls_query_padding_blocksize = 128;
			tls_authentication = "GETDNS_AUTHENTICATION_REQUIRED";
			dns_transport_list = [ "GETDNS_TRANSPORT_TLS" ];
			resolution_type = "GETDNS_RESOLUTION_STUB";
		};
	# } // loggingOptions;
	};

	networking.firewall.allowedTCPPorts = [ utilisedPort ];
	networking.firewall.allowedUDPPorts = [ utilisedPort ];
}



{ lib, config, pkgs, ... }:


let
	inherit (lib) mkIf;
in {


	services.dnscrypt-proxy2 = {
		enable = true;
		settings = {
			ipv6_servers = false;
			require_dnssec = true;

			sources.public-resolvers = {
				urls = [
					"https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
					"https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
				];
				cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
				minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
			};

			# You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
			# server_names = [ ... ];
		};
	};

	systemd.services.dnscrypt-proxy2.serviceConfig = {
		StateDirectory = "dnscrypt-proxy";
	};
}
