{
  config,
  lib,
  pkgs,
  ...
}: {
  # globally installed packages related to desktop use
  environment.systemPackages = with pkgs; [
    # [virtualisation]
    virt-manager
    looking-glass-client # best to use this with the kvmfr module for better performance if passing a dedicated gpu and using an igpu on the host
    # [gaming]
    steam # install via flatpak, less issues that way... + propietary apps should be installed via flatpak anyway, seems to have problems with gamescope so ill try the nixos way
    gamescope # steam compositor
  ];
  programs.virt-manager.enable = true;
  
}
