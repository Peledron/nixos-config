{
  config,
  lib,
  pkgs,
  modulesPath,
  self,
  ...
}: {
  imports =
    [(modulesPath + "/installer/scan/not-detected.nix")]
    ++ [(self + "/global/modules/hardware/amdGpu.nix")]
    ++ [(self + "/global/modules/hardware/bluetooth.nix")]
    ++ [(self + "/global/modules/hardware/drawingTablet.nix")]
    ++ [(self + "/global/modules/hardware/keychronKeyboard.nix")]
    ++ [(self + "/global/modules/hardware/gamingMouse.nix")];

  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ---
}
