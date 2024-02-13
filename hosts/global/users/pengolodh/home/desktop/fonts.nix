{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # font packages
    ubuntu_font_family
    font-awesome # font icons
    noto-fonts
    noto-fonts-emoji
    corefonts # ms fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode" # https://github.com/tonsky/FiraCode
        "Ubuntu"
        "UbuntuMono"
      ]; # adds specific programming ligatures
    })
  ];

  fonts = lib.mkDefault {
    fontconfig = {
      enable = true; # enabling this auto-detects installed fonts in home.packages and environment.packages
    };
  };
  gtk.font = {
    name = "Ubuntu";
    package = pkgs.ubuntu_font_family;
    size = 12;
  };
}
