{...}: {
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true; # launch sddm in wayland, enabling plasma6 luanches it using kwin
      };
    };
    desktopManager.plasma6.enable = true;
  };
}
