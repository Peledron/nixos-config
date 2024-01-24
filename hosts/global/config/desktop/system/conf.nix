{ config, lib, pkgs, ... }:
{
    imports =
        [(import ./services.nix)]
        ++ [(import ./pkgs.nix )]
    ;
}
