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
    ++ [(self + "/global/modules/hardware/asusLaptop.nix")]
    ++ [(self + "/global/modules/hardware/bluetooth.nix")];

  # base:
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # change to amd if that is used insead
  # ---
}
