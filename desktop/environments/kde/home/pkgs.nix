{pkgs, ...}: {
  home.packages = with pkgs; [
    # extra archiving tools needed for ark
    p7zip
    unrar
    lzop
    lrzip

    kdePackages.partitionmanager # kde-partition manager
    kdePackages.filelight # disk usage statistics
    kdePackages.discover # flatpak installer
    kdePackages.okular # pdf
    haruna # video player
  ];
}
