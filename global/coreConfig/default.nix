{...}: {
  imports = [
    ./conf.nix
    ./networking.nix
    ./pkgs.nix
    ./security.nix
    ./locale.nix
    ./services.nix
    ./usr.nix
  ];
}
