# system packages, accessible by all users, sys-packages holds system specific tools
{
  lib,
  pkgs,
  self,
  ...
}: {
  #imports= [(self + "/global/modules/programs/steam.nix")];
  #programs.steam.enable = false; # steam and its dependencies take up a very large amount of space
}
