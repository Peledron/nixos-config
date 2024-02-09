{
  config,
  lib,
  pkgs,
  ...
}: {
  # globally installed packages related to desktop use
  environment.systemPackages = with pkgs; [
    virt-manager
    looking-glass-client # best to use this with the kvmfr module for better performance if passing a dedicated gpu and using an igpu on the host
  ];
  programs.virt-manager.enable = true;
}
