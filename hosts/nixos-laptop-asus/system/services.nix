# important system services
{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [(self + "/hosts/global/modules/services/tlp.nix")];
}
