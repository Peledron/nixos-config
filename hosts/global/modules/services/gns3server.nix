{
  config,
  pkgs,
  lib,
  ...
}: {
  services.gns3-server = {
    enable = true;
    settings = {
      host = "127.0.0.1";
      port = 3080;
    };
    vpcs.enable = true; # enable vpcs support, this is a lightweight "pc" that has ping support for emulating a host
    ubridge.enable = true;
    dynamips.enable = true; # dynamips is used to emulate cisco IOS devices
  };
}
