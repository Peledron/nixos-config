{ config, ... }:
{   
    home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

    # [starship]
    programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true; # if you have fish enabled 
        #enableZshIntegration = true; # if you have zsh enabled 
        settings = {
            # See https://starship.rs/config/ for the full list of options.
            # converted from https://github.com/linuxmobile/hyprland-dots/blob/main/.config/starship/starship.toml

            scan_timeout = 10;

            format = "$all";
            right_format = """$git_branch$git_status$cmd_duration$directory""";

            # Disable the blank line at the start of the prompt
            add_newline = false;

            line_break = {
                disabled = true;
            };

            character = {
                success_symbol = " [](#6791c9)";
                error_symbol = " [](#df5b61)";
                vicmd_symbol = "[  ](#78b892)";
            };

            hostname = {
                ssh_only = true;
                format = "[$hostname](bold blue) ";
                disabled = false;
            };

            cmd_duration = {
                min_time = 1;
                format = "[](fg:#232526 bg:none)[$duration]($style)[](fg:#232526 bg:#232526)[](fg:#bc83e3 bg:#232526)[](fg:#232526 bg:#bc83e3)[](fg:#bc83e3 bg:none) ";
                disabled = false;
                style = "fg:#edeff0 bg:#232526";
            };

            directory = {
                format = "[](fg:#232526 bg:none)[$path]($style)[](fg:#232526 bg:#232526)[](fg:#6791c9 bg:#232526)[](fg:#232526 bg:#6791c9)[](fg:#6791c9 bg:none)";
                style = "fg:#edeff0 bg:#232526";
                truncation_length = 3;
                truncate_to_repo = false;
            };

            # [git]
            git_branch = {
                format = "[](fg:#232526 bg:none)[$branch]($style)[](fg:#232526 bg:#232526)[](fg:#78b892 bg:#232526)[](fg:#282c34 bg:#78b892)[](fg:#78b892 bg:none) ";
                style = "fg:#edeff0 bg:#232526";
            };

            git_status = {
                format="[](fg:#232526 bg:none)[$all_status$ahead_behind]($style)[](fg:#232526 bg:#232526)[](fg:#67afc1 bg:#232526)[](fg:#232526 bg:#67afc1)[](fg:#67afc1 bg:none) ";
                style = "fg:#edeff0 bg:#232526";
                conflicted = "=";
                ahead =	"⇡ ";
                behind = "⇣ ";
                diverged = "⇕⇡ ⇣ ";
                up_to_date = "";
                untracked = "? ";
                stashed = "";
                modified = "! ";
                staged = "+ ";
                renamed = "» ";
                deleted = " ";
            };

            git_commit = {
                format = "[\\($hash\\)]($style) [\\($tag\\)]($style)";
                style = "green";
            };

            git_state = {
                rebase = "REBASING";
                merge =	"MERGING";
                revert = "REVERTING";
                cherry_pick = "CHERRY-PICKING";
                bisect = "BISECTING";
                am = "AM";
                am_or_rebase = "AM/REBASE";
                style =	"yellow";
                format = "\([$state( $progress_current/$progress_total)]($style)\) ";
            };
        };
    };
}
