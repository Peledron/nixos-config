{ config, lib, pkgs, ... }:
{
    imports =
        [(import ./services.nix)]
        ++ [(import ./fonts.nix )]
    ;
}
