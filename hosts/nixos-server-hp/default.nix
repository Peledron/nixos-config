{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports =
    (import ./core)
    ++ (import ./system)
    ++ [(import ./containers/containers.nix)];
  system.autoUpgrade = false;
}
