{ config, lib, pkgs, system, imputs, ... }:
{
    home.packages = with pkgs; [
                starship
        ];

        #==================#
        # set programs to be managed by home-manager:
        # --> program configs are within ./configs
        #programs.firefox.enable = true;
}
