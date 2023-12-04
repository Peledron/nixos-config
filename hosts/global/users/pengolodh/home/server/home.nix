{ config, lib, pkgs, system, imputs, ... }:
{
    imports =
        [( import ./env.nix)]
        ++ [( import ./pkgs.nix)]
        ++ (import ./configs)
    ;
    home.stateVersion = "23.11";
}
