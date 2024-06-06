{
  config,
  lib,
  pkgs,
  ...
}: {
  home.xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["pcmanfm-qt.desktop"];
        
        "image/png" = ["org.nomacs.ImageLounge.desktop"];
        "image/jpeg" = ["org.nomacs.ImageLounge.desktop"];

        "application/x-xz-compressed-tar" = ["lxqt-archiver.desktop"];
      };
    };
  };
}
