{...}: {
  imports =
    (import ./core)
    ++ (import ./system)
    ++ [(import ./containers/containers.nix)];
  system.autoUpgrade.enable = false;
}
