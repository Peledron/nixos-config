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

        "image/png" = ["org.nomacs.ImageLounge.desktop"];
        "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];

        "application/x-xz-compressed-tar" = ["lxqt-archiver.desktop"];
      };
    };
  };
}
