{
	programs.starship = {
		settings = {
			# ├ ❯ ╰ ─ ┌ ❮	 
# FIXME(Krey): Due to a bug in nix parser this needs to be indented with spaces atm
###
      format = ''
        [](#9A348E)$os$username[@](bg:#9A348E)$hostname[](bg:#DA627D fg:#9A348E)$time[](fg:#DA627D bg:#33658A)$cmd_duration[](fg:#33658A)
        ├─ $directory$all
      '';
###

			# Git requires at least 300ms to load in it's module
			command_timeout = 300; # ms

			username = {
				show_always = true;
				style_user = "bg:#9A348E";
				style_root = "bg:#9A348E";
				format = "[$user]($style)";
			};

			hostname = {
					ssh_only = false;
					trim_at = "";
					format = "[$ssh_symbol$hostname ](bg:#9A348E)";
				};

			cmd_duration = {
				show_milliseconds = true;
				format = "[ $duration](fg:#FFFFFF bg:#33658A)";
				# FIXME(Krey): Can't be arsed to figure out how to make that work atm
				#min_time = "0_000";
			};

			time = {
				format = "[ $time ](fg:#FFFFFF bg:#DA627D)";
				time_format = "%T %d.%m.%Y %Z";
				disabled = false;
			};

			os = {
				style = "bg:#9A348E";
				disabled = false;
			};

			# FIXME(Krey): This should show exit status as well
			character = {
				format = "╰───$symbol ";
				success_symbol = "[❯](bold green)";
				error_symbol = "[❯](bold red)";
				vimcmd_symbol = "[❮](bold green)";
				vimcmd_replace_one_symbol = "[╰❮](bold purple)";
				vimcmd_replace_symbol = "[❮](bold purple)";
				vimcmd_visual_symbol = "[❮](bold yellow)";
			};
		};
	};
}
