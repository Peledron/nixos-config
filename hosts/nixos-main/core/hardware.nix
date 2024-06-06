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
    ++ [(self + "/hosts/global/modules/hardware/amd-gpu.nix")]
    ++ [(self + "/hosts/global/modules/hardware/bluetooth.nix")]
    ++ [(self + "/hosts/global/modules/hardware/rgb-control.nix")]
    ++ [(self + "/hosts/global/modules/hardware/drawing-tablet.nix")]
    ++ [(self + "/hosts/global/modules/hardware/keychron-keyboard.nix")]
    ++ [(self + "/hosts/global/modules/hardware/smartcard-reader.nix")];

  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # ---
}
