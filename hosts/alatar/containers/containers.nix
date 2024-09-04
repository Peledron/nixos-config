{...}: {
  imports =
    [(import ./container_networking.nix)]
    ++ (import ./nixos-containers);
}
