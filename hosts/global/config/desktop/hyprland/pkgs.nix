{ config, pkgs, lib, system, input, ... }:
let 
# 2 scripts taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
 dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = 
    let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gesettings/schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gesettings set $gnome_schema gtk-theme 'Qogir-Dark'
    '';
  };
in
{
    home.packages = with pkgs; [
        # [imported scripts]
        dbus-hyprland-environment
        configure-gtk

        # [theming]
        #nordic # application theming
        qogir-kde # qt
        qogir-theme # gtk
        papirus-icon-theme 

        # [qt-theming control]
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum

        # [wayland tools]
        grim # screenshotting tool for wayland
        slurp # screenshot region selection tool
        wf-recorder # screen recording for wayland
        wl-clipboard
        clipman
        wlr-randr # to set screensize
        swaybg # wallpaper tool for wayland
        swayidle # to allow the computer to go to sleep after a set period
        clipman
        waylock
        avizo # osd

        # [applets]
        networkmanagerapplet

        # [audio tools]
        pamixer
        pavucontrol
        playerctl
        
        # [file manager]
        #gnome.nautilus # file-manager
        #nautilus-open-any-terminal
        libsForQt5.dolphin
        libsForQt5.dolphin-plugins
        # [terminal]
        libsForQt5.konsole

        # [configured tools]
        # --> see ./hyprland/hm-conf.nix and ./hyprland/configs/*
        waybar
        dunst # notifications
        fuzzel # rofi alternative
        wlogout
    ];
}
