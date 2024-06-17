{
  config,
  pkgs,
  inputs,
  ...
}: {
  # [import declared configs]
  imports =
    [(import ./pkgs.nix)]
    ++ [(import ./theming.nix)]
    ++ [(import ./xdg.nix)]
    #++ [(import ./nvidia.nix)]
    ++ (import ./configs);
  # ---
}
