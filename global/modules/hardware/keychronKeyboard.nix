{pkgs, ...}: {
  hardware.keyboard.qmk.enable = true; # enable non-root users access to qmk firmware
  environment.systemPackages = with pkgs; [
    qmk
    via # keyboard control software --> gui program added in home-manager config
  ];
}
