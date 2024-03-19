# system packages, accessible by all users, sys-packages holds system specific tools
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports =
    [(self + "/hosts/global/modules/programs/steam.nix")]
    ++ [(self + "/hosts/global/modules/programs/vr.nix")];
}
