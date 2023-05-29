{ config, lib, pkgs, system, imputs, ... }:
{
    home.packages = with pkgs; [
            # cli tools
                # [shells]
                fish
                # [shell prompts]
                starship
                # [util replacements]
                bat # cat replacement with syntax highlighting, etc
                exa # colorfull ls, easier to read
                # [utils]
                #steam-run # allows you to run commands in the steam runtime env, usefull for running binaries that need FSH compatibility (not pure tho)
                # --> steam-run will keep steam installed
        ];

        #==================#
        # set programs to be managed by home-manager:
        # --> program configs are within ./configs
        #programs.firefox.enable = true;
}
