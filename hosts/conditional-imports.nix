{
  extraConfig,
  lib,
  self,
  ...
}: let
  modulePath = ${self}/global/modules;
in {
  imports = lib.flatten [
    (lib.optional (extraConfig.hardware.gpu == "amd") "${modulePath}/hardware/amdGpu.nix")

  ];
}
