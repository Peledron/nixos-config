{
  config,
  pkgs,
  inputs,
  ...
}: let
  split-monitor-workspaces = inputs.split-monitor-workspaces;
in {
  # [import declared configs]
  imports =
    [(import ./pkgs.nix)]
    ++ [(import ./theming.nix)]
    ++ [(import ./env.nix)]
    #++ [(import ./nvidia.nix)]
    ++ (import ./configs);
  # ---

}
