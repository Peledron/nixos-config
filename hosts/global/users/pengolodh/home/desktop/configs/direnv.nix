{config, ...}: {
  programs.direnv = {
    enable = true;
    nix-direnv = {
      # these options are the default, still beter to declare them explicitly
      enable = true;
      package = "pkgs.nix-direnv";
    };
    loadInNixShell = true;
  };
}
