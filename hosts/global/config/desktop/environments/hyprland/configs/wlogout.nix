{config, pkgs, ... }:
let
    logodir = "$HYPRCONF/resources/wlogout-logos";
in
{
    programs.wlogout = {
        enable = true;
        style = ''
            font-family: monospace;
            font-size: 14pt;
            color: #cdd6f4; /* text */
            background-color: rgba(30, 30, 46, 0.5);
            }

            button {
                background-repeat: no-repeat;
                background-position: center;
                background-size: 25%;
                border: none;
                background-color: rgba(30, 30, 46, 0);
                margin: 5px;
                transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
            }

            button:hover {
                background-color: rgba(49, 50, 68, 0.1);
            }

            button:focus {
                background-color: #cba6f7;
                color: #1e1e2e;
            }

            #lock {
                background-image: image(url("${logodir}/lock.png"));
            }
            #lock:focus {
                background-image: image(url("${logodir}/lock-hover.png"));
            }

            #logout {
                background-image: image(url("${logodir}/logout.png"));
            }
            #logout:focus {
                background-image: image(url("${logodir}/logout-hover.png"));
            }

            #suspend {
                background-image: image(url("${logodir}/sleep.png"));
            }
            #suspend:focus {
                background-image: image(url("${logodir}/sleep-hover.png"));
            }

            #shutdown {
                background-image: image(url("${logodir}/power.png"));
            }
            #shutdown:focus {
                background-image: image(url("${logodir}/power-hover.png"));
            }

            #reboot {
                background-image: image(url("${logodir}/restart.png"));
            }
            #reboot:focus {
                background-image: image(url("${logodir}/restart-hover.png"));
            }
        '';
        # ---

        # [buttons]
        layout.lock = {
            label = "lock";
            action = "swaylock -f";
            text = "Lock";
            keybind = "l";
        };
        layout.reboot = {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
        };
        layout.shutdown = {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
        };
        layout.logout = {
            label = "logout";
            action = "hyprctl dispatch exit 0";
            text = "Logout";
            keybind = "e";
        };
        layout.suspend = {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "u";
        };
    };
}
