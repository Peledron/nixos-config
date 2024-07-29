{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.sessionVariables = lib.mkDefault {
    EDITOR = "vim";
  };
}
