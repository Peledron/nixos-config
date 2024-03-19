{
  config,
  pkgs,
  callPackage,
  lib,
  ...
}: {
  # enable the xserver:
  services = {
    xserver = {
      enable = true;
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      #set de default login session to sddm and tell it to use plasma-wayland
      displayManager = {
        defaultSession = "plasma";
        sddm = {
          enable = true;
        };
      };
    };
    desktopManager.plasma6.enable = true;
  };
  programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)

  # --> install kde specific packages:
  environment.systemPackages = with pkgs; [
    # desktop specific
    # [kde]
    libsForQt5.polonium # tiling, package doesnt work with plasma 6
    # ark needs to be able to use compression applicatoiins
    p7zip
    unrar
    lzop
    lrzip
  ];
}
