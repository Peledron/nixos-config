{
  config,
  lib,
  pkgs,
  ...
}: let
  #scriptdir = "$HYPRCONF/resources/scripts";
in {
  programs.waybar = {
    enable = true;
    package = pkgs.unstable.waybar;
    #package = pkgs.waybar.overrideAttrs (oldAttrs: {mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];}); # enable the experimental patch to allow for hyprland workspaces indicator
    settings = {
      mainBar = {
        layer = "top"; # Waybar at top layer
        # position= "bottom"; # Waybar position (top|bottom|left|right)
        height = 16; # Waybar height (to be removed for auto height)

        # "gtk-layer-shell"= "false";

        # Choose the order of the modules
        modules-left = ["hyprland/workspaces"];
        #"modules-center"= ["sway/window"];
        modules-right = ["tray" "idle_inhibitor" "network" "cpu" "memory" "temperature" "pulseaudio" "pulseaudio#microphone" "clock"];

        # ---
        # module configs:

        "hyprland/workspaces" = {
          all-outputs = false;
          format = " {icon} ";
          format-icons = {
            urgent = "";
            focused = "";
            default = "";
          };
          on-scroll-up = "hyprctl dispatch split:workspace +1";
          on-scroll-down = "hyprctl dispatch split:workspace -1";
          persistent-workspaces = {
            "DP-1" = 5; # show 5 workspaces by default
            "DP-2" = 10;
          };
        };

        "idle_inhibitor" = {
          format = "| {icon}  |";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "bluetooth" = {
          on-click = "bluetoothctl power off";
          on-click-right = "bluetoothctl power on";
          format = "|  {status} |";
          format-connected = "|  {device_alias} |";
          format-connected-battery = "|  {device_alias} {device_battery_percentage}% |";
          # "format-device-preference"= [ "device1", "device2" ], # preference list deciding the displayed device
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

        "tray" = {
          # "icon-size"= 21;
          spacing = 10;
        };

        "clock" = {
          # "timezone"= "America/New_York";
          format = "|  {:%b %d %Y %R} |";
          tooltip-format = "<span color='#35b9ab'><big>{:%Y %B}</big></span>\n<span color='#35b9ab'><tt><small>{calendar}</small></tt></span>";
          format-alt = "| {:%a %d %b w:%V %H:%M} |";
          today-format = "<span color='#21a4df'><b><u>{}</u></b></span>";
          calendar-weeks-pos = "left";
          format-calendar = "<span background='#173f4f' bgalpha='60%'><b>{}</b></span>";
          format-calendar-weeks = "<span color='#73ba25'><b>{}</b></span>";
          format-calendar-weekdays = "<span color='#21a4df'><b>{}</b></span>";
          interval = 60;
        };

        "cpu" = {
          format = "| {usage}%   |";
          tooltip = true;
        };

        "memory" = {
          format = "| {}%   |";
        };

        "temperature" = {
          # "thermal-zone"= 2;
          "hwmon-path" = "/sys/class/hwmon/hwmon5/temp1_input";
          critical-threshold = 95;

          format = "| {temperatureC}°C {icon} |";
          format-icons = ["" "" ""];
          format-critical = "| {temperatureC}°C {icon} |";
        };

        "network" = {
          # "interface"= "wlp2*"; # (Optional) To force the use of this interface
          format-wifi = "|    |";
          format-ethernet = "| 󰈀  [ 󰇚 {bandwidthDownBytes} 󰕒 {bandwidthUpBytes} ] |";
          format-linked = "| 󰈁 |";
          format-disconnected = "| 󰈂 |";
          format-alt = "| {ifname} {essid} ({signalStrength}%) |";
          tooltip = false;
        };

        "pulseaudio" = {
          format = "| {volume}% {icon}  |";
          format-bluetooth = "| {volume}% {icon}  |";
          format-alt-click = "click-right";
          format-muted = "| 󰝟  |";
          format-icons = {
            headphones = "󰋋";
            handsfree = "󱡏";
            headset = "󰋎";
            hdmi = "󰡁";
            phone = "";
            portable = "";
            car = "";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          scroll-step = 2;
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "myxer";
          tooltip = true;
          ignored-sinks = ["Easy Effects Sink"]; # add audio devices that should be ignored
        };
        "pulseaudio#microphone" = {
          format = "| {format_source} |";
          format-source = "{volume}% ";
          format-source-muted = " Muted";
          on-click = "pamixer --default-source -t";
          on-scroll-up = "pamixer --default-source -i 5";
          on-scroll-down = "pamixer --default-source -d 5";
          scroll-step = 5;
        };
        # ---
      };
    };
    style = lib.mkDefault ''
      * {
          border:        none;
          border-radius: 0;
          font-family:   "UbuntuNerd";
          font-weight: bold;
          font-size:     15px;
          box-shadow:    none;
          text-shadow:   none;
          transition-duration: 0s;
      }

      window#waybar {
          color: #cdd6f4;
          background-color: rgba(40, 42, 51, 0.85);
          border-bottom: 2px solid rgba(53, 185, 171, 0.4);
      }

      window#waybar.solo {
          color: rgba(53, 185, 171, 1);
      }

      tooltip {
          background: #282a33;
          border-radius: 10px;
          border-width: 2px;
          border-style: solid;
          border-color: #33eeff;
      }

      #workspaces {
          margin: 0 5px;
      }

      #custom-scratchpad {
          margin: 0px	5px;
          padding: 0px 5px;
      }

      #workspaces button {
          padding: 0 5px;
          color: #ffffff;
          margin-right: 5px;
      }
      #workspaces button.focused {
          color: #EBCB8B;
      }
      #workspaces button.active {
          color: #EBCB8B;
      }

      #workspaces button.visible {
          color: #EBCB8B;
      }

      #workspaces button.urgent {
          color: #11111b;
      }

      #mode,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #idle_inhibitor,
      #temperature,
      #custom-layout,
      #backlight {
          margin: 0px 6px 0px 10px;
      }

      #clock {
          margin: 0px 6px 0px 10px;
      }

      #battery.warning {
      color: rgba(255, 210, 4, 1);
      }

      #battery.critical {
          color: rgba(238, 46, 36, 1);
      }

      #battery.charging {
          color: rgba(217, 216, 216, 1);
      }
    '';
    #systemd.enable = true; # if you want it to autostart at graphical-target reached
  };
}
