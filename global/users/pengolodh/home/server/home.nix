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
    ++ (import ./configs);
}
