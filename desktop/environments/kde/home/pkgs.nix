{pkgs, ...}: {
  home.packages = with pkgs; [
    p7zip
    unrar
    lzop
    lrzip

    kdePackages.partitionmanager # kde-partition manager
    kdePackages.filelight # disk usage statistics
    kdePackages.kate # text editor
    kdePackages.discover # flatpak installer
  ];
}
