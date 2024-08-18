{pkgs, ...}: {
  services.ratbagd.enable = true;
  nvironment.systemPackages = with pkgs; [
    piper
  ];
}
