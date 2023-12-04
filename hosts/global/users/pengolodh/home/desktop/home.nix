{ config, lib, pkgs, system, imputs, ... }:
{
    imports =
        [( import ./env.nix)]
        ++ [( import ./pkgs.nix)] 
        ++ [( import ./locations.nix)]
        ++ (import ./configs)
    ;
    home.stateVersion = "23.11";
}
