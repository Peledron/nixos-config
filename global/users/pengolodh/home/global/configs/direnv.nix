{
  pkgs,
  lib,
  ...
}: {
  programs.direnv = {
    enable = lib.mkDefault false;
    nix-direnv = {
      # these options are the default, still beter to declare them explicitly
      enable = true;
    };
    enableBashIntegration = true;
  };
}
