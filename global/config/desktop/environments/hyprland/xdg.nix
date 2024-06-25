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

        "image/png" = ["org.gnome.eog.desktop"];
        "image/jpeg" = ["org.gnome.eog.desktop"];

        "application/x-xz-compressed-tar" = ["org.gnome.file-roller.desktop"];
      };
      associations.added = lib.mkAfter {
        "image/png" = ["org.gnome.eog.desktop"];
        "image/jpeg" = ["org.gnome.eog.desktop"];
      };
    };
  };
}
