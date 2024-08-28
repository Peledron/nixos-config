{...}: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./filesystems.nix
    ./ephemeral.nix
    ./networking.nix
  ];
}
