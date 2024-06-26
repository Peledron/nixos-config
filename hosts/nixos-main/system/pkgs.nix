# system packages, accessible by all users, sys-packages holds system specific tools
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports=[(self + "/global/modules/programs/steam.nix")];
}
