{lib, ...}: {
  environment.sessionVariables = lib.mkDefault {
    EDITOR = "vim";
  };
}
