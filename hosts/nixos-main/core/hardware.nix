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
    ++ [(self + "/global/modules/hardware/amd-gpu.nix")]
    ++ [(self + "/global/modules/hardware/bluetooth.nix")]
    ++ [(self + "/global/modules/hardware/rgb-control.nix")]
    ++ [(self + "/global/modules/hardware/drawing-tablet.nix")]
    ++ [(self + "/global/modules/hardware/keychron-keyboard.nix")]
    ++ [(self + "/global/modules/hardware/smartcard-reader.nix")];

  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ---
}
