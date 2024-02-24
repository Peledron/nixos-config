{ config, lib, pkgs, system, imputs, ... }:
{
    home.sessionVariables = rec {
        # common variables
        EDITOR = "micro";
        VISUAL = "vscodium"; # the visual variables is for the defualt command to run the full-fledged editor that is used for more demanding tasks
        BROWSER = "firefox";
    };
}
