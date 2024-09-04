{...}: {
  imports =
    [
      ./boot.nix
      ./hardware.nix
      ./filesystems.nix
      ./ephemeral.nix
      ./networking.nix
      ./services.nix
    ]
    ++ [(import ./containers/containers.nix)];
  system.autoUpgrade.enable = false;
}
