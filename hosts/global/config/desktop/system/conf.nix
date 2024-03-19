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
    ++ [(self + "/hosts/global/modules/virt/desktop-virt.nix")];
}
