{
  config,
  lib,
  self,
  ...
}:
let
  cfg = config.hardware;
  hwModulesPath = ${self}/global/modules/hardware;
in {
  options.hardware = {
    gpu = mkOption {
      type = types.enum ["amd" "nvidia" "intel"];
      description = "The type of GPU in the system.";
    };
    bluetooth = mkEnableOption "Bluetooth support";
    drawingTablet = mkEnableOption "Drawing tablet support";
    keychron = mkEnableOption "Keychron keyboard support";
    smartcardReader = mkEnableOption "Smart card reader support";
  };
  config = {
    imports = [
      (mkIf (cfg.gpu == "amd") ${hwModulesPath}/amdGpu.nix)
      (mkIf cfg.bluetooth ${hwModulesPath}/bluetooth.nix)
      (mkIf cfg.drawingTablet ${hwModulesPath}/drawingTablet.nix)
      (mkIf cfg.keychron ${hwModulesPath}/keychronKeyboard.nix)
      (mkIf cfg.smartcardReader ${hwModulesPath}/smartcardReader.nix)
    ];
  };
}
