{pkgs, ...}: {
  services.ratbagd.enable = true;
  home-manager.sharedModules = [
    {
      home.packages = with pkgs; [
        piper
      ];
    }
  ];
}
