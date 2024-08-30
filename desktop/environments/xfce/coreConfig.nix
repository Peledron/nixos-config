{...}: {
  # xfce:
  services.xserver = {
    enable = true;
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
  };
  programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)
}
