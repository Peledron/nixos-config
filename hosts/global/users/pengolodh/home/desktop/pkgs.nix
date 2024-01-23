{ config, lib, pkgs, system, imputs, ... }:
{
    home.packages = with pkgs; [
            # applications
                # [browsers]
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
                # [pdf]
                libsForQt5.okular

            # cli tools
                # [shell prompts]
                starship
                # [utils]
 
        ];

        #==================#
        # set programs to be managed by home-manager:
        # --> program configs are within ./configs
        #programs.firefox.enable = true;

}
