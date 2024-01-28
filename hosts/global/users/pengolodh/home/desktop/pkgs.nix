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
                #steam # install via flatpak, less issues that way...
                #heroic # install via flatpak

            # development
                # [programming langs]
                python3
                go
                openjdk
                # [programming tools]
                alejandra # nix-formatter
                meld # diff tool
                
                # [editors]
                vscodium-fhs
                
                # [pdf]
                libsForQt5.okular

            # cli tools
                # [shell prompts]
                # -> defined in the global core config
                # [utils]
 
        ];

        #==================#
        # set programs to be managed by home-manager:
        # --> program configs are within ./configs
        #programs.firefox.enable = true;

}
