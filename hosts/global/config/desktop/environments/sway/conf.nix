{config, pkgs, ... }:
{
    imports =
        [(import ./pkgs.nix)]
        ++ [(import ./theming.nix)]
    ;
}
