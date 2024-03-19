{
  config,
  pkgs,
  lib,
  ...
}: {
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}
