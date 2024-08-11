{
  config,
  lib,
  pkgs,
  ...
}: {
  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = lib.mkAfter {
        "inode/directory" = ["nemo.desktop"];
      };
      associations.added = lib.mkAfter {
        "inode/directory" = ["nemo.desktop"];
      };
    };
  };
}
