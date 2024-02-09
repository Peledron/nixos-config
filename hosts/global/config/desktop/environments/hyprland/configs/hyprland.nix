{
  config,
  pkgs,
  self,
  inputs,
  ...
}: let
  split-monitor-workspaces = inputs.split-monitor-workspaces;
  wallpaper = "${self}/hosts/global/config/desktop/environments/hyprland/configs/non-nix/wallpapers/wallpaper.png";
  lockscreen = "${self}/hosts/global/config/desktop/environments/hyprland/configs/non-nix/wallpapers/lockscreen.jpg";
  wobsock = "$XDG_RUNTIME_DIR/wob.sock"; # file where values that wob needs for showing levels are stored
  mod = "SUPER";

  # applications
  term = "konsole";
  browser = "firefox";
  file-man = "dolphin";
  email = "thunderbird";
  runner = "fuzzel";
in {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true; #
    systemd = {
      # activates the dbus environment for hyprland on graphical-target, this is added to the conf file
      enable = true;

      variables = ["-all"];
      /*
      extraCommands = [
        "systemctl --user restart pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-hyprland"
        # im not sure why this is needed, taken from https://github.com/abdul2906/nixos-system-config/blob/main/nixos/modules/hyprland/module.nix
      ];
      */
      #  im leaving this blanc since I think its for when hyprland reloads, not really needed in this case since we use systemd
    };
    plugins = [
      split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      # see https://github.com/skbolton/nix-dotfiles/blob/main/home/capabilities/desktop/hyprland/default.nix for a good example of this type of config
      # [variables]
      "$screenshotarea" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'";
      # [exec]
      exec-once = [
        ### basic
        "waybar"
        "sleep 2; pkill -USR1 waybar" # hides waybar on reload
        "swayidle timeout 900 'swaylock -f -i ${lockscreen}' timeout 1200 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 1800 'systemctl suspend' before-sleep 'swaylock -f -i ${lockscreen}'"
        "wl-paste -t text --watch clipman store --no-persist --max-items=999999"
        ### applets
        "vorta -d"
        "nm-applet"
        "blueman-applet"
        #"nextcloud --background"
      ];
      exec = [
        ### basic
        "dunst"
        "rm -f ${wobsock} && mkfifo ${wobsock} && tail -f ${wobsock} | wob"
        "swaybg -m fill -i ${wallpaper}"
      ];

      # [monitors]
      # see https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",highrr,auto,1"; # you can also add bitdepth 10,

      # [input settings]
      # see https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        ### keyboard
        kb_layout = "us";
        numlock_by_default = true;

        ### focus
        follow_mouse = 1; # 1 always fully switches focus, 2 allows mouse nav in other windows but not typing until clicked
        mouse_refocus = false;
        float_switch_override_focus = 0; # prevents focus from being stolen when switching to and from floating windows, fixes right click windows on some programs not staying open when we try to select options in them

        ### mouse
        accel_profile = "flat";
        sensitivity = 0.15; # -1.0 - 1.0, 0 means no modification

        touchpad = {
          middle_button_emulation = true;
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      gestures = {
        workspace_swipe = true;
      };

      # [hyprland settings]
      # [general settings]
      general = {
        ### windowing
        layout = "dwindle";
        gaps_in = 3;
        gaps_out = 3;
        ### border
        no_border_on_floating = true;
        border_size = 2;
        "col.active_border " = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;

        enable_swallow = true; # swallowing closes a program when a new program is launched from it, the new program "swallows" it
        swallow_regex = "^(${term})$"; # swallow_regex only applies swallowing to the following, in this case my terminal application
        vrr = 2; # vrr 2 means only fullscreen, 1 means all time
      };

      xwayland = {
        force_zero_scaling = true;
      };

      # [layouts]
      # layout selection is made in general.layout
      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to {mod} + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      # [look and feel]
      decoration = {
        ## corner rounding
        rounding = 3;
        ## opacity
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        ## shadow
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = 2;
        shadow_range = 4;
        shadow_render_power = 2;
        "col.shadow" = "0x66000000";
      };

      # [keybinds]
      bind =
        [
          # programs
          "${mod}, space, exec, killall ${runner} || ${runner}"
          "${mod}, C, exec, ${term}"
          "${mod}, W, exec, ${browser}"
          "${mod}, E, exec, ${file-man}"
          
          ", Print, exec, grimblast copy area"

          # window management
          "${mod}, X, killactive,"
          "${mod} SHIFT, Q, exit,"
          "${mod}, F, fullscreen,"
          "${mod} SHIFT, F, togglefloating,"

          # layout managemnt
          "${mod}, P, pseudo," # dwindle
          "${mod}, S, togglesplit," # dwindle

          # window focus
          "${mod}, left, movefocus, l"
          "${mod}, right, movefocus, r"
          "${mod}, up, movefocus, u"
          "${mod}, down, movefocus, d"

          # window movement
          "${mod} SHIFT, left, movewindow, l"
          "${mod} SHIFT, right, movewindow, r"
          "${mod} SHIFT, up, movewindow, u"
          "${mod} SHIFT, down, movewindow, d"

          # window resizing
          "${mod} CTRL, left, resizeactive, -80 0"
          "${mod} CTRL, right, resizeactive, 80 0"
          "${mod} CTRL, up, resizeactive, 0 -80"
          "${mod} CTRL, down, resizeactive, 0 80"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "${mod}, ${ws}, workspace, ${toString (x + 1)}"
                "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };
}
