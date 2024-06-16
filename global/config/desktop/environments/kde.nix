{
  config,
  pkgs,
  callPackage,
  lib,
  ...
}: {
  # enable the xserver:
  services = {
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true; # launch sddm in wayland
      };
    };
    desktopManager.plasma6.enable = true;
  };
  programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)
  #programs.gnupg.agent.pinentryPackage = lib.mkForce pkgs.pinentry-qt;
  # --> install kde specific packages:
  environment.systemPackages = with pkgs.unstable; [
    # desktop specific
    # [kde]
    libsForQt5.polonium # tiling, package doesnt work with plasma 6
    # ark needs to be able to use compression applicatoiins
    p7zip
    unrar
    lzop
    lrzip

    kdePackages.partitionmanager # kde-partition manager
    kdePackages.filelight # disk usage statistics
    kdePackages.kate # text editor
  ];
}