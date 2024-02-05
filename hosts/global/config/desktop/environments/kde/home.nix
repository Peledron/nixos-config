{
  config,
  pkgs,
  ...
}: {
  # [import declared configs]
  imports =
    [(import ./env.nix)]
    #++ [(import ./theming.nix)]
    ++ [(import ./pkgs.nix)]
    # ++ [(import ./plasma.nix)]
    ;
}
