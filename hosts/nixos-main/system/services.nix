# important system services
{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"]; # tell x11 to use amdgpu driver
}
