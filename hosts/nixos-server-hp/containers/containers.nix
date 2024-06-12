{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports =
    [(import ./container_networking.nix)]
    ++ (import ./nixos-containers);
}