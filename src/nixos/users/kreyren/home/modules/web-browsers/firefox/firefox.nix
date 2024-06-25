{ config, pkgs, lib, firefox-addons, ... }:

# WELCOME TO THE WORLD OF MINDFUCKERY SUCKAAAA!

# TODO(Krey)
# * `Performance -> Use recommended performance settings` is expected to be blocked by policy to be impossible to toggle back on
# * Figure out how to set the default web browser

let
	inherit (lib) mkForce;
in {
	programs.firefox = {
		package = pkgs.firefox;
		# Refer to https://mozilla.github.io/policy-templates or `about:policies#documentation` in firefox
		policies = {
			AppAutoUpdate = false; # Disable automatic application update
			BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
			DisableBuiltinPDFViewer = true; # Considered a security liability
			DisableFirefoxStudies = true;
			DisableFirefoxAccounts = true; # Disable Firefox Sync
			DisableFirefoxScreenshots = true; # No screenshots?
			DisableForgetButton = true; # Thing that can wipe history for X time, handled differently
			DisableMasterPasswordCreation = true; # To be determined how to handle master password
			DisableProfileImport = true; # Purity enforcement: Only allow nix-defined profiles
			DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
			DisableSetDesktopBackground = true; # Remove the “Set As Desktop Background…” menuitem when right clicking on an image, because Nix is the only thing that can manage the backgroud
			DisplayMenuBar = "default-off";
			DisablePocket = true;
			DisableTelemetry = true;
			DisableFormHistory = true;
			DisablePasswordReveal = true;
			DontCheckDefaultBrowser = true; # Stop being attention whore
			HardwareAcceleration = false; # Disabled as it's exposes points for fingerprinting
			OfferToSaveLogins = false; # Managed by KeepAss instead
			EnableTrackingProtection = {
				Value = true;
				Locked = true;
				Cryptomining = true;
				Fingerprinting = true;
				EmailTracking = true;
				# Exceptions = ["https://example.com"]
			};
			EncryptedMediaExtensions = {
				Enabled = true;
				Locked = true;
			};
			ExtensionUpdate = false;
			# FIXME(Krey): Review `~/.mozilla/firefox/Default/extensions.json` and uninstall all unwanted
			# Suggested by t0b0 thank you <3 https://gitlab.com/engmark/root/-/blob/60468eb82572d9a663b58498ce08fafbe545b808/configuration.nix#L293-310
			# NOTE(Krey): Check if the addon is packaged on https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
			ExtensionSettings = {
				"*" = {
					installation_mode = "blocked";
					blocked_install_message = "FUCKING FORGET IT!";
				};
				"{b43b974b-1d3a-4232-b226-eaa2ac6ebb69}" = {
					# Random User-Agent Switcher
					install_url = "https://addons.mozilla.org/firefox/downloads/latest/random_user_agent/latest.xpi";
					installation_mode = "force_installed";
				};
				"addon@darkreader.org" = {
					# Dark Reader
					install_url = "file:///${firefox-addons.darkreader}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/addon@darkreader.org.xpi";
					installation_mode = "force_installed";
				};
				"7esoorv3@alefvanoon.anonaddy.me" = {
					# LibRedirect
					install_url = "file:///${firefox-addons.libredirect}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/7esoorv3@alefvanoon.anonaddy.me.xpi";
					installation_mode = "force_installed";
				};
				"jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack" = {
					# Terms of Service, Didn't Read
					install_url = "file:///${firefox-addons.terms-of-service-didnt-read}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack.xpi";
					installation_mode = "force_installed";
				};
				"{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
					# Refined Github
					install_url = "file:///${firefox-addons.refined-github}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}.xpi";
					installation_mode = "force_installed";
				};
				# FIXME(Krey): Figure out how to handle this
				# "keepassxc-browser@keepassxc.org" = {
				# 	# KeepAssXC-Browser
				# 	install_url = "file:///${firefox-addons.keepassxc-browser}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/keepassxc-browser@keepassxc.org.xpi";
				# 	installation_mode = "force_installed";
				# };
				# FIXME(Krey): Figure out if we want this
				# "jid1-BoFifL9Vbdl2zQ@jetpack" = {
				# 	# Decentrayeles
				# 	install_url = "file:///${firefox-addons.decentraleyes}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/jid1-BoFifL9Vbdl2zQ@jetpack.xpi";
				# 	installation_mode = "force_installed";
				# };
				# FIXME(Krey): Figure out if we want this
				# "{73a6fe31-595d-460b-a920-fcc0f8843232}" = {
				# 	# NoScript
				# 	install_url = "file:///${firefox-addons.noscript}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi";
				# 	installation_mode = "force_installed";
				# };
				"{74145f27-f039-47ce-a470-a662b129930a}" = {
					# ClearURLs
					install_url = "file:///${firefox-addons.clearurls}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/{74145f27-f039-47ce-a470-a662b129930a}.xpi";
					installation_mode = "force_installed";
				};
				"sponsorBlocker@ajay.app" = {
					# Sponsor Block
					install_url = "file:///${firefox-addons.sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/sponsorBlocker@ajay.app.xpi";
					installation_mode = "force_installed";
				};
				"uBlock0@raymondhill.net" = {
					# uBlock Origin
					install_url = "file:///${firefox-addons.ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/uBlock0@raymondhill.net.xpi";
					installation_mode = "force_installed";
				};
			};

			"3rdparty".Extensions = {
				# # https://github.com/libredirect/browser_extension/blob/b3457faf1bdcca0b17872e30b379a7ae55bc8fd0/src/config.json
				# "7esoorv3@alefvanoon.anonaddy.me" = {
				# 	# FIXME-UPSTREAM(Krey): This doesn't work, implementation tracked in https://github.com/libredirect/browser_extension/issues/905
				# 	services.youtube.options.enabled = true;
				# };
				# https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
				"uBlock0@raymondhill.net".adminSettings = {
					userSettings = rec {
						uiTheme = "dark";
						uiAccentCustom = true;
						uiAccentCustom0 = "#8300ff";
						cloudStorageEnabled = mkForce false; # Security liability?
						importedLists = [
							"https://filters.adtidy.org/extension/ublock/filters/3.txt"
							"https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
						];
						externalLists = lib.concatStringsSep "\n" importedLists;
					};
					selectedFilterLists = [
						"CZE-0"
						"adguard-generic"
						"adguard-annoyance"
						"adguard-social"
						"adguard-spyware-url"
						"easylist"
						"easyprivacy"
						"https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
						"plowe-0"
						"ublock-abuse"
						"ublock-badware"
						"ublock-filters"
						"ublock-privacy"
						"ublock-quick-fixes"
						"ublock-unbreak"
						"urlhaus-1"
					];
				};
			};

			FirefoxHome = {
				Search = true;
				TopSites = true;
				SponsoredTopSites = false; # Fuck you
				Highlights = true;
				Pocket = false;
				SponsoredPocket = false; # Fuck you
				Snippets = false;
				Locked = true;
			};
			FirefoxSuggest = {
				WebSuggestions = false;
				SponsoredSuggestions = false; # Fuck you
				ImproveSuggest = false;
				Locked = true;
			};
			Handlers = {
				# FIXME-QA(Krey): Should be openned in evince if on GNOME
				mimeTypes."application/pdf".action = "saveToDisk";
			};
			extensions = {
				pdf = {
					action = "useHelperApp";
					ask = true;
					# FIXME-QA(Krey): Should only happen on GNOME
					handlers = [
						{
							name = "GNOME Document Viewer";
							path = "${pkgs.evince}/bin/evince";
						}
					];
				};
			};
			NoDefaultBookmarks = true;
			PasswordManagerEnabled = false; # Managed by KeepAss
			PDFjs = {
				Enabled = false; # Fuck No, HELL NO
				EnablePermissions = false;
			};
			# Permissions = {
			# 	Camera = {
			# 		Allow = [https =//example.org,https =//example.org =1234];
			# 		Block = [https =//example.edu];
			# 		BlockNewRequests = true;
			# 		Locked = true
			# 	};
			# 	Microphone = {
			# 		Allow = [https =//example.org];
			# 		Block = [https =//example.edu];
			# 		BlockNewRequests = true;
			# 		Locked = true
			# 	};
			# 	Location = {
			# 		Allow = [https =//example.org];
			# 		Block = [https =//example.edu];
			# 		BlockNewRequests = true;
			# 		Locked = true
			# 	};
			# 	Notifications = {
			# 		Allow = [https =//example.org];
			# 		Block = [https =//example.edu];
			# 		BlockNewRequests = true;
			# 		Locked = true
			# 	};
			# 	Autoplay = {
			# 		Allow = [https =//example.org];
			# 		Block = [https =//example.edu];
			# 		Default = allow-audio-video | block-audio | block-audio-video;
			# 		Locked = true
			# 	};
			# };
			PictureInPicture = {
				Enabled = true;
				Locked = true;
			};
			PromptForDownloadLocation = true;
			Proxy = {
				Mode = "manual"; # none | system | manual | autoDetect | autoConfig;
				Locked = true; # Do not allow the user to change the proxy settings
				# HTTPProxy = hostname;
				# UseHTTPProxyForAllProtocols = true;
				# SSLProxy = hostname;
				# FTPProxy = hostname;
				SOCKSProxy = "127.0.0.1:9050"; # Tor
				SOCKSVersion = 5; # 4 | 5
				#Passthrough = <local>;
				# AutoConfigURL = URL_TO_AUTOCONFIG;
				# AutoLogin = true;
				UseProxyForDNS = true;
			};
			SanitizeOnShutdown = {
				Cache = true;
				Cookies = false;
				Downloads = true;
				FormData = true;
				History = false;
				Sessions = false;
				SiteSettings = false;
				OfflineApps = true;
				Locked = true;
			};
			SearchEngines = {
				PreventInstalls = true;
				Add = [
					{
						Name = "SearXNG";
						URLTemplate = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/search?q={searchTerms}";
						Method = "GET"; # GET | POST
						IconURL = "http://searx3aolosaf3urwnhpynlhuokqsgz47si4pzz5hvb7uuzyjncl2tid.onion/favicon.ico";
						# Alias = example;
						Description = "SearX instance ran by tiekoetter.com as onion-service";
						#PostData = name=value&q={searchTerms};
						#SuggestURLTemplate = https =//www.example.org/suggestions/q={searchTerms}
					}
				];
				Remove = [
					"Amazon.com" # Fuck you
					"Bing" # Fuck you
					"Google" # FUCK YOUU
				];
				Default = "SearXNG";
			};
			SearchSuggestEnabled = false;
			ShowHomeButton = true;
			# FIXME-SECURITY(Krey): Decide what to do with this
			# SSLVersionMax = tls1 | tls1.1 | tls1.2 | tls1.3;
			# SSLVersionMin = tls1 | tls1.1 | tls1.2 | tls1.3;
			# SupportMenu = {
			# 	Title = Support Menu;
			# 	URL = http =//example.com/support;
			# 	AccessKey = S
			# };
			StartDownloadsInTempDirectory = true; # For speed? May fuck up the system on low ram
			UserMessaging = {
				ExtensionRecommendations = false; # Don’t recommend extensions while the user is visiting web pages
				FeatureRecommendations = false; # Don’t recommend browser features
				Locked = true; # Prevent the user from changing user messaging preferences
				MoreFromMozilla = false; # Don’t show the “More from Mozilla” section in Preferences
				SkipOnboarding = true; # Don’t show onboarding messages on the new tab page
				UrlbarInterventions = false; # Don’t offer suggestions in the URL bar
				WhatsNew = false; # Remove the “What’s New” icon and menuitem
			};
			UseSystemPrintDialog = true;
			# WebsiteFilter = {
			# 	Block = [<all_urls>];
			# 	Exceptions = [http =//example.org/*]
			# };
		};
		arkenfox = {
			enable = false; # Decide how we want to handle these things
			version = "118.0"; # Used on 119.0, because we don't have firefox 118.0 handy
		};

		profiles.Default = {
			settings = {
			# Enable letterboxing
			"privacy.resistFingerprinting.letterboxing" = true;

			# WebGL
			"webgl.disabled" = true;

			"browser.preferences.defaultPerformanceSettings.enabled" = false;
			"layers.acceleration.disabled" = true;
			"privacy.globalprivacycontrol.enabled" = true;

			"browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

			# "network.trr.mode" = 3;

			# "network.dns.disableIPv6" = false;

			"privacy.donottrackheader.enabled" = true;

			# "privacy.clearOnShutdown.history" = true;
			# "privacy.clearOnShutdown.downloads" = true;
			# "browser.sessionstore.resume_from_crash" = true;

			# See https://librewolf.net/docs/faq/#how-do-i-fully-prevent-autoplay for options
			"media.autoplay.blocking_policy" = 2;

			"privacy.resistFingerprinting" = true;

			"signon.management.page.breach-alerts.enabled" = false; # Disable firefox password checking against a breach database
			};
			# Documentation https://arkenfox.dwarfmaster.net
			arkenfox = if (config.programs.firefox.arkenfox.version == "118.0") then {
				enable = true;

				# STARTUP
				"0105".enable = true; # Disable sponsored content on Firefox Home (Activity Stream)

				# GEOLOCATION / LANGUAGE / LOCALE
				"0201".enable = true; # Use Mozilla geolocation service instead of Google if permission is granted [FF74+]
				"0202".enable = true; # Disable using the OS's geolocation service
				# WARNING(Krey): May break some input methods e.g xim/ibus for CJK languages [1]
				"0211".enable = true; # Use en-US locale regardless of the system or region locale

				# QUIETER FOX (Handles telemetry, etc..)
				"0300".enable = true;

				# BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on]
				"0600".enable = true;

				# DNS / DoH / PROXY / SOCKS / IPV6
				"0701".enable = true; # Disable IPv6 as it's potentially leaky
				"0704".enable = true; # Disable GIO as a potential proxy bypass vector

				# LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
				"0802".enable = true; # disable location bar domain guessing

				# PASSWORDS
				"0900".enable = true;

				# HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
				"1200".enable = true;

				# FONTS
				"1400".enable = true;

				# HEADERS ? REFERERS
				"1600".enable = true;

				# CONTAINERS
				"1700".enable = true;

				# PLUGINS / MEDIA / WEBRTC
				"2002".enable = true; # Force WebRTC inside the proxy [FF70+]
				"2003".enable = true; # Force a single network interface for ICE candidates generation [FF42+]
				"2004".enable = true; # Force exclusion of private IPs from ICE candidates [FF51+]
				"2020".enable = true; # Disable GMP (Gecko Media Plugins) - https://wiki.mozilla.org/GeckoMediaPlugins

				# DOM (DOCUMENT OBJECT MODEL)
				"2400".enable = true; # Prevent scrips from resizing open windows (could be used for fingerprinting)

				# MISCELLANEOUS
				"2603".enable = true; # Remove temp files opened with an external application on exit
				"2606".enable = true; # Disable UITour backend so there is no chance that a remote page can use it
				"2608".enable = true; # Reset remote debugging to disabled
				"2615".enable = true; # Disable websites overriding Firefox's keyboard shortcuts [FF58+]
				"2616".enable = true; # Remove special permissions for certain mozilla domains [FF35+]
				"2617".enable = true; # Remove webchannel whitelist (Seems to be deprecated with mozilla having still permissions in it)
				"2619".enable = true; # Use Punycode in Internationalized Domain Names to eliminate possible spoofing
				"2620".enable = true; # Enforce PDFJS, disable PDFJS scripting
				"2621".enable = true; # Disable links launching Windows Store on Windows 8/8.1/10 [WINDOWS]
				"2623".enable = true; # Disable permissions delegation [FF73+], Disabling delegation means any prompts for these will show/use their correct 3rd party origin
				"2624".enable = true; # Disable middle click on new tab button opening URLs or searches using clipboard [FF115+]
				"2651".enable = true; # Enable user interaction for security by always asking where to download
				"2652".enable = true; # Disable downloads panel opening on every download [FF96+]
				"2654".enable = true; # Enable user interaction for security by always asking how to handle new mimetypes [FF101+]
				"2662".enable = true; # Disable webextension restrictions on certain mozilla domains (you also need 4503) [FF60+]
					"4503".enable = true; # Disable mozAddonManager Web API [FF57+]

				# ETP (ENHANCED TRACKING PROTECTION)
				"2700".enable = true;

				"2811".enable = true; # Set/enforce what items to clear on shutdown (if 2810 is true) [SETUP-CHROME]
				"2812".enable = true; # Set Session Restore to clear on shutdown (if 2810 is true) [FF34+]
				"2815".enable = true; # Set "Cookies" and "Site Data" to clear on shutdown (if 2810 is true) [SETUP-CHROME]

				# EFP (RESIST FINGERPRINTING)
				"4500".enable = true;

				# OPTIONAL OPSEC
				"5003".enable = true; # Disable saving passwords
				"5004".enable = true; # Disable permissions manager from writing to disk [FF41+] [RESTART], This means any permission changes are session only

				# OPTIONAL HARDENING
				## NOTE(Krey): There are new vulnerabilities discovered in 2023, better disable it for now
				"5505".enable = true; # Diable Ion and baseline JIT to harden against JS exploits

				# DONT TOUTCH
				## NOTE(Krey): By default arkenfox flake sets all options are set to disabled, and these are expected to be always enabled
				"6000".enable = true;

				# DONT BOTHER
				"7001".enable = true; # Disables Location-Aware Browsing, Full Screen Geo is behind a prompt (7002). Full screen requires user interaction
				"7003".enable = true; # Disable non-modern cipher suites
				"7004".enable = true; # Control TLS Versions, because they are used as a passive fingerprinting
				"7005".enable = true; # Disable SSL Session IDs [FF36+]
				"7006".enable = true; # Onions
				"7007".enable = true; # Referencers, only cross-origin referers (1600s) need control
				"7013".enable = true; # Disable Clipboard API
				"7014".enable = true; # Disable System Add-on updates (Managed by Nix)

				# NON-PROJECT RELATED
				"9002".enable = true; # Disable General>Browsing>Recommend extensions/features as you browse [FF67+]
			} else if (config.programs.firefox.arkenfox.version == "") then {
				# FIXME-QA(Krey); Should just be a neutral state, dunno how to set it
				"2700".enable = true; # All Good
			} else
				throw ("This arkenfox version" + config.programs.firefox.arkenfox.version + "is not implemented!");
			settings = {
				"network.proxy.socks_remote_dns" = true; # Do DNS lookup through proxy (required for tor to work)
			};
		};
	};
}
