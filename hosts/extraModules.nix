{
  config,
  lib,
  self,
  extraModules,
  ...
}: let
  defaultExtraModules = {
    theme = null;
    hardware = {
      gpu = null;
      bluetooth = false;
      drawingTablet = false;
      logitechMouse = false;
      keychronKeyboard = false;
      smartcardReader = false;
    };
    virt = {
      desktop = false;
      podman = false;
    };
  };

  mergedModules =
    defaultExtraModules
    // {
      hardware = defaultExtraModules.hardware // extraModules.hardware;
      virt = defaultExtraModules.virt // extraModules.virt;
    };

  modulesPath = "${self}/global/modules";
  hwModulesPath = "${modulesPath}/hardware";
  virtModulesPath = "${modulesPath}/virt";
  themingModulesPath = "${modulesPath}/theming";
  imports = lib.flatten [
    # hardware
    (lib.optional (mergedModules.hardware.gpu == "amd") "${hwModulesPath}/amdGpu.nix")
    (lib.optional mergedModules.hardware.bluetooth "${hwModulesPath}/bluetooth.nix")
    (lib.optional mergedModules.hardware.drawingTablet "${hwModulesPath}/drawingTablet.nix")
    (lib.optional mergedModules.hardware.logitechMouse "${hwModulesPath}/logitechMouse.nix")
    (lib.optional mergedModules.hardware.keychronKeyboard "${hwModulesPath}/keychronKeyboard.nix")
    (lib.optional mergedModules.hardware.smartcardReader "${hwModulesPath}/smartcardReader.nix")
    # virt
    (lib.optional mergedModules.virt.desktop "${virtModulesPath}/desktopVirt.nix")
    (lib.optional mergedModules.virt.podman "${virtModulesPath}/podman.nix")
    # theming
    (lib.optional (mergedModules.theme == "nord") "${themingModulesPath}/nord.nix")
  ];
in {
  inherit imports;
}
