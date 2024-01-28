{config, pkgs, ... }:
{
    # [import declared configs]
    imports =
        [(import ./env.nix)]
        # ++ [(import ./pkgs.nix)]
        # ++ [(import ./plasma.nix)]
    ;
}