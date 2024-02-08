{
  config,
  pkgs,
  ...
}: let
  wallpaper = "${self}/hosts/global/config/desktop/environments/hyprland/configs/non-nix/wallpapers/wallpaper.png";
  lockscreeen = "${self}/hosts/global/config/desktop/environments/hyprland/configs/non-nix/wallpapers/lockscreen.jpg";
in {
  wayland.windowManager.hyprland = {
    systemd = {
      # activates the dbus environment for hyprland on graphical-target, this is added to the conf file
      enable = true;
      xwayland.enable = true; #
      variables = ["-all"];
      /*
      extraCommands = [
        "systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland"
        # im not sure why this is needed, taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
      ];
      */
      # -> im leaving this blanc since I think its for when hyprland reloads, not really needed in this case since we use systemd
    };
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      # [variables]
      "$mainMod" = "SUPER";
      # [exec]
      ## exec-once on startup
      ## exec whenever hyprland is reloaded
      exec = "${pkgs.dunst}/bin/dunst";
      ### applets
      exec = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      exec = "${pkgs.blueman}/bin/blueman-applet";
    };
  };
}
