{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports =
    [(import ./services.nix)]
    ++ [(import ./pkgs.nix)]
    # [module imports]
    ++ [(self + "/global/modules/virt/desktop-virt.nix")];
}
