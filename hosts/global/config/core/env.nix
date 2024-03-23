{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.variables = lib.mkDefault {
    EDITOR = "vim";
  };
}
