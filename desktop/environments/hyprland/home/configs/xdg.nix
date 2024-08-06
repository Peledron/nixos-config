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
        "application/x-xz-compressed-tar" = ["org.gnome.file-roller.desktop"];
      };
      associations.added = lib.mkAfter {
        "inode/directory" = ["nemo.desktop"];
      };
    };
  };
}
