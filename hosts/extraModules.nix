{
  lib,
  self,
  extraModules,
  ...
}: let
  defaultExtraModules = {
    theme = "none";
    hardware = {
      gpu = "none";
      asusLaptop = false;
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
    // extraModules
    // {
      hardware = defaultExtraModules.hardware // extraModules.hardware;
      virt = defaultExtraModules.virt // extraModules.virt;
    };

  modulesPath = "${self}/global/modules";
  hwModulesPath = "${modulesPath}/hardware";
  virtModulesPath = "${modulesPath}/virt";
  themingModulesPath = "${modulesPath}/theming";

  preconfigThemes = ["nord"]; #
  preconfigThemeImport = theme: lib.optional (builtins.elem theme preconfigThemes) "${themingModulesPath}/${theme}.nix"; # theme is the input, if that input matches any of the themes in the preconfigthemes list then import that module
  # --> note that the module name and the base16 theme name must be the same, so da-one-gray 
  imports = lib.flatten [
    # hardware
    (lib.optional (mergedModules.hardware.gpu == "amd") "${hwModulesPath}/amdGpu.nix")
    (lib.optional mergedModules.hardware.asusLaptop "${hwModulesPath}/asusLaptop.nix")
    (lib.optional mergedModules.hardware.bluetooth "${hwModulesPath}/bluetooth.nix")
    (lib.optional mergedModules.hardware.drawingTablet "${hwModulesPath}/drawingTablet.nix")
    (lib.optional mergedModules.hardware.logitechMouse "${hwModulesPath}/logitechMouse.nix")
    (lib.optional mergedModules.hardware.keychronKeyboard "${hwModulesPath}/keychronKeyboard.nix")
    (lib.optional mergedModules.hardware.smartcardReader "${hwModulesPath}/smartcardReader.nix")
    # virt
    (lib.optional mergedModules.virt.desktop "${virtModulesPath}/desktopVirt.nix")
    (lib.optional mergedModules.virt.podman "${virtModulesPath}/podman.nix")
    # theming
    (lib.optional (mergedModules.theme != "none") "${themingModulesPath}/base16.nix")
    (preconfigThemeImport mergedModules.theme)
  ];
in {
  inherit imports;
}
