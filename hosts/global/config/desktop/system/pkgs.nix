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
    gamescope # steam compositor
  ];
  programs.virt-manager.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Add cap_sys_nice capability to the GameScope binary so that it may renice itself
    args = [
      #"--rt"
    ];
  };
}
