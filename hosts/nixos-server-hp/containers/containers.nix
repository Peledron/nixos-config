{
  config,
  lib,
  pkgs,
  system,
  inputs,
  self,
  ...
}: {
  imports =
    [(import ./container_networking.nix)]
    ++ (import ./nixos-containers)
    ++ (import ./OCI-podman);
}
