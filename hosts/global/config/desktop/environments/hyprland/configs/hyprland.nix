{
  config,
  pkgs,
  self,
  inputs,
  ...
}: let
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
    #ypackage = inputs.hyprland.packages.${pkgs.system}.hyprland; # needed to allow plugins
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
      #inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces # -> does not work for some reason
    ];
    settings = {
      # see https://github.com/skbolton/nix-dotfiles/blob/main/home/capabilities/desktop/hyprland/default.nix for a good example of this type of config
      # [variables]
      "$screenshotarea" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify copysave area; hyprctl keyword animation 'fadeOut,1,4,default'";
      "$screenshotscreen" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify --cursor copysave output; hyprctl keyword animation 'fadeOut,1,4,default'";
      "$screenshotall" = "hyprctl keyword animation 'fadeOut,0,0,default'; grimblast --notify --cursor copysave screen; hyprctl keyword animation 'fadeOut,1,4,default'";

      "$volup" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ && pamixer --get-volume > ${wobsock}";
      "$voldown" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- && pamixer --get-volume > ${wobsock}";
      "$inmute" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      "$outmute" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ( [ '$(pamixer --get-mute)' = 'true' ] && echo 0 > ${wobsock} ) || pamixer --get-volume > ${wobsock}";

      "$brightup" = "brightnessctl -q set +5% && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > ${wobsock} )"; # -> you need to have brightnessctl installed
      "$brightdown" = "brightnessctl -q set 5%- && ( echo $((`brightnessctl get` * 100 / `brightnessctl m`)) > ${wobsock} )";

      # [env]
      # -> best set this in ../env.nix, ill put some here cuz they are temporary
      env = [
        "WLR_DRM_NO_ATOMIC,1" # for tearing support
      ];

      # [exec]
      exec-once = [
        ## theming related
        "configure-gtk" # -> see ../theming.nix for what this does
        "waypaper --restore"
        ## basic
        "dunst"
        "waybar"
        "sleep 2; pkill -USR1 waybar" # hides waybar on reload
        "swayidle timeout 900 'swaylock -f -i ${lockscreen}' timeout 1200 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' timeout 1800 'systemctl suspend' before-sleep 'swaylock -f -i ${lockscreen}'"
        "wl-paste -t text --watch clipman store --no-persist --max-items=999999"
        ## applets
        "vorta -d"
        "nm-applet"
        "blueman-applet"
        #"nextcloud --background"
      ];
      exec = [
        ## basic
        "rm -f ${wobsock} && mkfifo ${wobsock} && tail -f ${wobsock} | wob"
        #"swaybg -m fill -i ${wallpaper}"
      ];

      # [monitors]
      # see https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",highrr,auto,1"; # you can also add bitdepth 10,

      # [input settings]
      # see https://wiki.hyprland.org/Configuring/Variables/#input
      input = {
        ## keyboard
        kb_layout = "us";
        numlock_by_default = true;

        ## focus
        follow_mouse = 1; # 1 always fully switches focus, 2 allows mouse nav in other windows but not typing until clicked
        mouse_refocus = false;
        float_switch_override_focus = 0; # prevents focus from being stolen when switching to and from floating windows, fixes right click windows on some programs not staying open when we try to select options in them

        ## mouse
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
      general = {
        ## windowing
        layout = "dwindle";
        gaps_in = 3;
        gaps_out = 3;
        ## border
        no_border_on_floating = true;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        ## allow tearing
        allow_tearing = true; # see https://wiki.hyprland.org/Configuring/Tearing/
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = false;
        mouse_move_enables_dpms = true;

        enable_swallow = true; # swallowing closes a program when a new program is launched from it, the new program "swallows" it
        swallow_regex = "^(${term})$"; # swallow_regex only applies swallowing to the following, in this case my terminal application
        vrr = 2; # vrr 2 means only fullscreen variable refresh rate, 1 means all time, leaving this on 1 causes brightness flickering on my monitors sadly
      };
      xwayland = {
        force_zero_scaling = true;
      };

      # [layouts]
      # default layout selection is defined in general.layout, this defines the way that the layout works
      # See https://wiki.hyprland.org/Configuring/Master-Layout/
      dwindle = {
        no_gaps_when_only = false;
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to {mod} + P in the keybinds section below
        preserve_split = true; # you probably want this
      };
      master = {
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
        shadow_offset = "2 2";
        shadow_range = 4;
        shadow_render_power = 2;
        "col.shadow" = "0x66000000";

        blur = {
          popups = true; # whether to blur popups (e.g. right-click menus)
        };
        ## blur specific applications
        blurls = [
          "gtk-layer-shell"
          "swaync-client"
          "swaync"
          "lockscreen"
          "launcher"
          "notifications"
          "wob"
          "title:branchdialog"
          "splash"
          "org.kde.konsole"
          "org.kde.dolphin"
        ];
      };
      animations = {
        ## see https://wiki.hyprland.org/Configuring/Animations
        enabled = true;
        ## bezier curves
        ## see http://wiki.hyprland.org/Configuring/Animations/#curves
        bezier = [
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "smoothOut, 0.63, 0.36, 0, 0.99"
          "smoothIn, 0.25, 1, 0.5, 1"
        ];
        ## animations
        animation = [
          "windows, 1, 2, overshot, slide"
          "windowsOut, 1, 2, smoothOut"
          "windowsMove, 1, 3, default"
          "border, 1, 5, default"
          "fade, 1, 5, smoothIn"
          "fadeDim, 1, 5, smoothIn"
          "workspaces, 1, 3, default"
        ];
      };

      # [window rules]
      windowrule = [
        ## float pop-ups, file-picker, etc..
        "float, file_progress"
        "float, confirm"
        "float, dialog"
        "float, download"
        "float, notification, monitor"
        "float, error"
        "float, splash"
        "float, confirmreset"
        "float, title:Open File"
        "float, title:branchdialog"
        "float, org.kde.polkit-kde-authentication-agent-1"
        "float, org.gnome.polkit-gnome-authentication-agent-1"
        "float, title:^(Media viewer)$"
        "float, title:^(Volume Control)$"
        "float, title:^(Picture-in-Picture)$"
        "size 800 600, title:^(Volume Control)$"
        "move 75 44%, title:^(Volume Control)$"

        ## set programs to inhibit idle when fullscreen
        "idleinhibit focus, mpv"
        "idleinhibit fullscreen, firefox"

        ## float programs
        "float, pavucontrol-qt"
        "float, pavucontrol"
        "float, file-roller"
        "float, steam"
        "float, waypaper"

        ## set wlogout to be fullscreen
        "fullscreen, title:wlogout"

        ## set chrome to be borderless fullscreen
        "fakefullscreen, class:^(Google-Chrome)$"

        ## allow tearing on gamescope/steam windows
        "immediate, class:^(.gamescope-wrapped)$"
        "immediate, class:^steam_app_*"
      ];

      # [keybinds]
      # see https://wiki.hyprland.org/0.35.0/Configuring/Binds/
      bind =
        [
          ## programs
          "${mod}, space, exec, killall ${runner} || ${runner}" # || means that it will do the first or the second, depending if the runner is already spawned or not, a toggle switch basically
          "${mod}, C, exec, ${term}"
          "${mod}, W, exec, ${browser}"
          "${mod}, E, exec, ${file-man}"
          "${mod}, V, exec, clipman pick --max-items=99999 --tool=CUSTOM --tool-args='${runner} -d'" # clipboard picker using fuzzel

          ## screenshotting
          ", print, exec, $screenshotarea" # print selected rectangle, $screenshotarea is defined in variables of hyprland itself (see above)
          "SHIFT, print, exec, $screenshotscreen" # per screen
          "CTRL, print, exec, $screenshotall" # entireoutput

          ## logout/lockscreens
          "${mod}, escape, exec, wlogout --protocol layer-shell -b 5 -T 400 -B 400"
          "CTRL ALT, L, exec, swaylock --daemonize --image ${lockscreen}"

          ## media keys
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          ## hide/show waybar
          "${mod}, B, exec, pkill -USR1 waybar || pkill -USR1 waybar"

          ## window management
          "${mod}, X, killactive,"
          "${mod} SHIFT, Q, exit,"
          "${mod}, F, fullscreen,"
          "${mod} SHIFT, F, togglefloating,"

          ### tiling layout managemnt
          "${mod}, P, pseudo," # dwindle
          "${mod}, S, togglesplit," # dwindle

          ### window focus
          "${mod}, left, movefocus, l" # the key at the end is an alternative key
          "${mod}, right, movefocus, r"
          "${mod}, up, movefocus, u"
          "${mod}, down, movefocus, d"

          ### window movement
          "${mod} SHIFT, left, movewindow, l"
          "${mod} SHIFT, right, movewindow, r"
          "${mod} SHIFT, up, movewindow, u"
          "${mod} SHIFT, down, movewindow, d"

          ### window resizing
          "${mod} CTRL, left, resizeactive, -80 0"
          "${mod} CTRL, right, resizeactive, 80 0"
          "${mod} CTRL, up, resizeactive, 0 -80"
          "${mod} CTRL, down, resizeactive, 0 80"

          ## mouse keys
          "${mod}, mouse_up, workspace, e-1"
          "${mod}, mouse_down, workspace, e+1"
        ]
        ++ (
          ## workspaces/ workspace movement
          ## --> taken from hyprland wiki home-man example https://wiki.hyprland.org/0.35.0/Nix/Hyprland-on-Home-Manager/
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
      # "binde" flags bind with e, meaning that the key will be repeated when pressed, see http://wiki.hyprland.org/0.35.0/Configuring/Binds/#bind-flags for more flags
      binde = [
        # in this case I will use it for the volume/brightness control keys
        ", XF86AudioRaiseVolume, exec, $volup"
        ", XF86AudioLowerVolume, exec, $voldown"
        ", XF86AudioMute, exec, $outmute"
        ", XF86AudioMicMut, exec, $inmute"
        ", XF86MonBrightnessUp, exec, $brightup"
        ", XF86MonBrightnessDown, exec, $brightdown"
      ];
      # "bindm" binds mouse actions
      bindm = [
        "${mod}, mouse:272, movewindow"
        "${mod}, mouse:273, resizewindow"
      ];
    };
  };
}
