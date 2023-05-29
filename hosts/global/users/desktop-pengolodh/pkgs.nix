{ config, lib, pkgs, system, imputs, ... }:
{
    home.packages = with pkgs; [
            # applications
                # [browsers]
                # firefox-wayland --> see ./configs/firefox.nix as it is enabled there (otherwise there is a collision) ==> https://nixos.wiki/wiki/Firefox
                # [backup-solution]
                vorta
                # [creative]
                #blender
                #krita
                # [gaming]
                #steam
                #heroic

            # development
                # [programming langs]
                python3
                go
                openjdk
                # [editors]
                kate
                obsidian
                vscodium-fhs # fhs version allows for extention installion
                meld

            # cli tools
		# [dotfiles management] # I should define all config in nix but...
		stow	
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
