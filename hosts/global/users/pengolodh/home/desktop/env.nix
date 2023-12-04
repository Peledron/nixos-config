{ config, lib, pkgs, system, imputs, ... }:
{
    home.sessionVariables = rec {
        # custom vars:
        FLAKEDIR="$HOME/nixos-config"; # the directory of the flake
        NIXBIN="/run/current-system/sw/bin";
        NIXLIB="/run/current-system/sw/lib";
        USRNIXBIN="/etc/profiles/per-user/$USER/bin";
    };
}
