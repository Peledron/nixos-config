{...}: {
  imports =
    [(import ./env.nix)]
    ++ [(import ./pkgs.nix)]
    ++ (import ./configs);
}
