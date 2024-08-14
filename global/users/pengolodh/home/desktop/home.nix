{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports =
    [(import ./env.nix)]
    ++ [(import ./pkgs.nix)]
    ++ [(import ./locations.nix)]
    ++ [(import ./fonts.nix)]
    ++ [(import ./xdg.nix)]
    ++ (import ./configs);
}
