{
  config,
  pkgs,
  lib,
  system,
  input,
  ...
}: {
  home.packages = with pkgs; [
    libsForQt5.partitionmanager # kde-partition manager
    libsForQt5.filelight # disk usage statistics
    libsForQt5.kate # text editor
    haruna # video player
  ];
}
