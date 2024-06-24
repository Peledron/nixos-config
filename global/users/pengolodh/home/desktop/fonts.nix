{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    corefonts # ms fonts
  ];
  fonts.fontconfig.enable = true; # enabling this auto-detects installed fonts in home.packages and environment.packages

  stylix.fonts = {
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
    monospace = {
      name = "UbuntuMono Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["UbuntuMono"];};
    };
    sansSerif = {
      name = "Ubuntu Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["Ubuntu"];};
    };
    serif = {
      name = "Ubuntu Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["Ubuntu"];};
    };
    sizes = {
      applications = 12;
      terminal = 15;
      desktop = 12;
      popups = 12;
    };
  };
}
