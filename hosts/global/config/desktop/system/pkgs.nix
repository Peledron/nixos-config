{
  config,
  lib,
  pkgs,
  ...
}: {
  # globally installed packages related to desktop use
  environment.systemPackages = with pkgs; [
    virt-manager
    tuxclocker # overclocking/monitoring utility for gpu's and cpu's, defined here as it needs to be at system level
  ];
  programs.virt-manager.enable = true;
  programs.tuxclocker = {
    enable = true;
    enableAMD = true;
    # enabledNVIDIADevices []; best do this in an nvidia only config file...
    useUnfree = false;
  };
}
