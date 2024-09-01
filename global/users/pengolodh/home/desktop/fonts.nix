{pkgs, ...}: {
  home.packages = with pkgs; [
    corefonts # ms fonts
  ];
  fonts.fontconfig.enable = true; # enabling this auto-detects installed fonts in home.packages and environment.packages

  stylix.fonts = {
    sansSerif = {
      name = "UbuntuSans Nerd Font Med";
      package = pkgs.nerdfonts.override {fonts = ["UbuntuSans"];};
    };
    serif = {
      name = "Ubuntu Nerd Font Med";
      package = pkgs.nerdfonts.override {fonts = ["Ubuntu"];};
    };
    monospace = {
      name = "UbuntuMono Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["UbuntuMono"];};
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
    sizes = {
      applications = 13;
      terminal = 14;
      desktop = 13;
      popups = 13;
    };
  };
}
