{...}: {
  hardware.cpu.amd.updateMicrocode = true;
  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}