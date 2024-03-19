# important system services
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports =
    [(self + "/hosts/global/modules/virt/podman.nix")]
    ++ [(self + "/hosts/global/modules/services/rkvmserver.nix")];
}
