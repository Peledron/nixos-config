{
  config,
  lib,
  self,
  extraConfig,
  ...
}: let
  modulesPath = "${self}/global/modules";
  hwModulesPath = "${modulesPath}/hardware";
  virtModulesPath = "${modulesPath}/virt";
in {
  imports = [
    # hardware
    (lib.mkIf (extraConfig.hardware.gpu == "amd") "${hwModulesPath}/amdGpu.nix")
    (lib.mkIf extraConfig.hardware.bluetooth "${hwModulesPath}/bluetooth.nix")
    (lib.mkIf extraConfig.hardware.drawingTablet "${hwModulesPath}/drawingTablet.nix")
    (lib.mkIf extraConfig.hardware.logitechMouse "${hwModulesPath}/logitechMouse.nix")
    (lib.mkIf extraConfig.hardware.keychronKeyboard "${hwModulesPath}/keychronKeyboard.nix")
    (lib.mkIf extraConfig.hardware.smartcardReader "${hwModulesPath}/smartcardReader.nix")
    # virt
    (lib.mkIf extraConfig.virt.desktop "${virtModulesPath}/desktopVirt.nix")
    (lib.mkIf extraConfig.virt.podman "${virtModulesPath}/podman.nix")
  ];
}
