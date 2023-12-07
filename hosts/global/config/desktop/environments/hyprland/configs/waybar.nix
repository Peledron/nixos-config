{config, pkgs, ... }:
let
    scriptdir = "$HYPRCONF/resources/scripts";
in
{
    programs.waybar = {
        enable = true;
        settings = {
            layer = "top";
            position = "top";
            mod = "dock";
            exclusive = "true";
            passthrough = false;
            gtk-layer-shell = "true";
            height = "0";

            # [layout]
            modules-left = [
                "clock"
                "custom/weather"
                "wlr/workspaces"
            ];
            modules-center = ["hyprland/window"];
            modules-right = [
                "tray"
                "custom/updates"
                "custom/language"
                "battery"
                "backlight"
                "pulseaudio"
                "pulseaudio#microphone"
            ];
            
            # [modules]
            # --> internal
            tray = {
                icon-size = 13;
                spacing = 10;
            };

            clock = {
                format = "{= %R   %d/%m}";
                tooltip-format = "<big>{=%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };

            backlight = {
                device = "intel_backlight";
                format = "{icon} {percent}%";
                format-icons = "[, , ]";
                on-scroll-up = "brightnessctl set 1%+";
                on-scroll-down = "brightnessctl set 1%-";
                min-length = 6;
            };

            battery = {
                states = {
                    good = 95;
                    warning = 30;
                    critical = 20;
                };
                format = "{icon} {capacity}%";
                format-charging = " {capacity}%";
                format-plugged = " {capacity}%";
                format-alt = "{time} {icon}";
                format-icons = ["" "" "" "" "" "" "" "" "" "" ""];
            };

            pulseaudio = {
                format = "{icon} {volume}%";
                tooltip = false;
                format-muted = " Muted";
                on-click = "pamixer -t";
                on-scroll-up = "pamixer -i 5";
                on-scroll-down = "pamixer -d 5";
                scroll-step = 5;
                format-icons = {
                    headphone = "";
                    hands-free = "";
                    headset = "";
                    phone = "";
                    portable = "";
                    car = "";
                    default = ["" "" ""];
                };
            };

            "pulseaudio#microphone" = {
                format = "{format_source}";
                format-source = " {volume}%";
                format-source-muted = " Muted";
                on-click = "pamixer --default-source -t";
                on-scroll-up = "pamixer --default-source -i 5";
                on-scroll-down = "pamixer --default-source -d 5";
                scroll-step = 5;
            };

            # --> external
            "hyprland/window" = {
                format = "{}";
            };

            "wlr/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
                on-click = "activate";
                #format = {icon};
                /*
                persistent_workspaces = {
                    1 = "[]";
                    2 = "[]";
                    3 = "[]";
                    4 = "[]";
                    5 = "[]";
                    6 = "[]";
                    7 = "[]";
                    8 = "[]";
                    9 = "[]";
                    10 = "[]";
                };*/
            };

            /*
            custom/updates = {
                exec = (pacman -Qu ; yay -Qua) | wc -l;
                interval = 7200;
                format =  {}
            };
            */

            "custom/weather" = {
                tooltip = true;
                format = "{}";
                interval = 30;
                exec = "${scriptdir}/waybar-wttr.py";
                return-type  = "json";
            };  
        };
        style = ''
            * {
                border: none;
                border-radius: 0;
                font-family: Cartograph CF Nerd Font, monospace;
                font-weight: bold;
                font-size: 14px;
                min-height: 0;
            }

            window#waybar {
                background: rgba(21, 18, 27, 0);
                color: #cdd6f4;
            }

            tooltip {
                background: #1e1e2e;
                border-radius: 10px;
                border-width: 2px;
                border-style: solid;
                border-color: #11111b;
            }

            #workspaces button {
                padding: 5px;
                color: #313244;
                margin-right: 5px;
            }

            #workspaces button.active {
                color: #a6adc8;
            }

            #workspaces button.focused {
                color: #a6adc8;
                background: #eba0ac;
                border-radius: 10px;
            }

            #workspaces button.urgent {
                color: #11111b;
                background: #a6e3a1;
                border-radius: 10px;
            }

            #workspaces button:hover {
                background: #11111b;
                color: #cdd6f4;
                border-radius: 10px;
            }

            #custom-language,
            #custom-updates,
            #custom-caffeine,
            #custom-weather,
            #window,
            #clock,
            #battery,
            #pulseaudio,
            #network,
            #workspaces,
            #tray,
            #backlight {
                background: #1e1e2e;
                padding: 0px 10px;
                margin: 3px 0px;
                margin-top: 10px;
                border: 1px solid #181825;
            }

            #tray {
                border-radius: 10px;
                margin-right: 10px;
            }

            #workspaces {
                background: #1e1e2e;
                border-radius: 10px;
                margin-left: 10px;
                padding-right: 0px;
                padding-left: 5px;
            }

            #custom-caffeine {
                color: #89dceb;
                border-radius: 10px 0px 0px 10px;
                border-right: 0px;
                margin-left: 10px;
            }

            #custom-language {
                color: #f38ba8;
                border-left: 0px;
                border-right: 0px;
            }

            #custom-updates {
                color: #f5c2e7;
                border-left: 0px;
                border-right: 0px;
            }

            #window {
                border-radius: 10px;
                margin-left: 60px;
                margin-right: 60px;
            }

            #clock {
                color: #fab387;
                border-radius: 10px 0px 0px 10px;
                margin-left: 0px;
                border-right: 0px;
            }

            #network {
                color: #f9e2af;
                border-left: 0px;
                border-right: 0px;
            }

            #pulseaudio {
                color: #89b4fa;
                border-left: 0px;
                border-right: 0px;
            }

            #pulseaudio.microphone {
                color: #cba6f7;
                border-left: 0px;
                border-right: 0px;
            }

            #battery {
                color: #a6e3a1;
                border-radius: 0 10px 10px 0;
                margin-right: 10px;
                border-left: 0px;
            }

            #custom-weather {
                border-radius: 0px 10px 10px 0px;
                border-right: 0px;
                margin-left: 0px;
            }
        '';
        #systemd.enable = true; # if you want it to autostart at graphical-target reached
    };

}