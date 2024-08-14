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
        "image/jpeg" = ["org.kde.gwenview.desktop"];
        "image/png" = ["org.kde.gwenview.desktop"];
        "image/webp" = ["org.kde.gwenview.desktop"];
        "image/heic" = ["org.kde.gwenview.desktop"];
      };
      associations.added = lib.mkAfter {
        "inode/directory" = ["nemo.desktop"];
        "image/jpeg" = ["org.kde.gwenview.desktop"];
        "image/png" = ["org.kde.gwenview.desktop"];
        "image/webp" = ["org.kde.gwenview.desktop"];
        "image/heic" = ["org.kde.gwenview.desktop"];
      };
    };
  };
}
