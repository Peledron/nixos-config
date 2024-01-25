{ config, lib, pkgs, ... }:
{
# globally installed packages related to desktop use
    environment.systemPackages = with pkgs; [
        virt-manager
        vscodium-fhs
        
    ];
    programs.virt-manager.enable = true;

}
