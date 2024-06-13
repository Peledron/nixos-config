{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alvr
    android-tools
    sidequest
  ];
  programs = {
    alvr = {
      enable = true;
      openFirewall = true;
    };
  };
}
