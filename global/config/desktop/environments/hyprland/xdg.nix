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
        "inode/directory" = ["pcmanfm-qt.desktop"];

        "image/png" = ["org.gnome.eog.desktop"];
        "image/jpeg" = ["org.gnome.eog.desktop"];

        "application/x-xz-compressed-tar" = ["lxqt-archiver.desktop"];
      };
      associations.added = lib.mkAfter {
        "image/png" = ["org.gnome.eog.desktop"];
        "image/jpeg" = ["org.gnome.eog.desktop"];
      };
    };
  };
}
