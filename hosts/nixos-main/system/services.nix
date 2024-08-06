# important system services
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports =
    [(self + "/global/modules/virt/podman.nix")]
    ++ [(self + "/global/modules/services/rkvmserver.nix")]
    ++ [(self + "/global/modules/services/gns3.nix")];
  #services.mullvad-vpn.enable = true;
}
