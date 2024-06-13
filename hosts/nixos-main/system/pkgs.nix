# system packages, accessible by all users, sys-packages holds system specific tools
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  #[(self + "/global/modules/programs/steam.nix")];
}
