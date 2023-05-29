{ config, pkgs, callPackage, lib, ... }:
{
    # enable xserver and gdm
    services.xserver = {
        enable = true;
        libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
    };
    programs.dconf.enable = true; # better compatiblity for costum setups (gnome apps)
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ]; # enable gnome settings udev rules
    # --> install extentions:
    environment.systemPackages = with pkgs; [
        gnomeExtensions.appindicator  # tray-icons
        #gnomeExtensions.pop-shell # pop-os tiling
    ];
    
    # --> disable gnome-specific packages:
    environment.gnome.excludePackages = (with pkgs; [
        gnome-photos
        gnome-tour
        gnome-help
    ]) ++ (with pkgs.gnome; [
        epiphany # web browser
        evince # document viewer
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
    ]);
    
}