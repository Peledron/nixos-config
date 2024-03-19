# system packages, accessible by all users, sys-packages holds system specific tools
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports =
    [(self + "/hosts/global/modules/programs/steam.nix")]
    ++ [(self + "/hosts/global/modules/programs/vr.nix")]
    ++ [(self + "/hosts/global/modules/programs/gns3.nix")];
}
