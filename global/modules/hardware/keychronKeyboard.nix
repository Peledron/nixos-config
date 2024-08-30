{pkgs, ...}: {
  hardware.keyboard.qmk.enable = true; # enable non-root users access to qmk firmware
  home-manager.sharedModules = [
    {
      home.packages = with pkgs; [
        qmk
        via
      ];
    }
  ];
}
