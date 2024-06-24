{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [(self + "/global/modules/theming/nord.nix")];
}
