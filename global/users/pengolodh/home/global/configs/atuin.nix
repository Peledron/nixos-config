{lib, ...}: {
  programs.atuin = {
    enable = lib.mkDefault false;
  };
}
