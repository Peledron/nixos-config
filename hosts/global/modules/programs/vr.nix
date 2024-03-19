{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    alvr
  ];
  programs = {
    alvr = lib.mkDefault {
      enable = false;
      openFirewall = true;
    };
  };
}
