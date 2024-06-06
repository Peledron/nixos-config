{
  config,
  pkgs,
  self,
  ...
}: let
  logodir = "${self}/hosts/global/config/desktop/environments/hyprland/configs/non-nix/wlogout-logos";
in {
  programs.wlogout = {
    enable = true;
    package = pkgs.wlogout;
    style = ''
       window {
          font-family: monospace;
          font-size: 14pt;
          color: #cdd6f4; /* text */
          background-color:  rgba(40, 42, 51, 0.5);
      }

      button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border-style: solid;
          border-width: 2px;
          border-color: #33eeff;
          background-color: rgba(40, 42, 51, 1);
          margin: 5px;
          transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }

      button:hover {
          background-color: rgba(40, 42, 51, 0.1);
      }

      button:focus {
          background-color:  #33eeff;
          color: #1e1e2e;
      }

      #lock {
          background-image: url("${logodir}/lock.png");
      }
      #lock:focus {
          background-image: url("${logodir}/lock-hover.png");
      }

      #logout {
          background-image: url("${logodir}/logout.png");
      }
      #logout:focus {
          background-image:url("${logodir}/logout-hover.png");
      }

      #suspend {
          background-image: url("${logodir}/sleep.png");
      }
      #suspend:focus {
          background-image: url("${logodir}/sleep-hover.png");
      }

      #shutdown {
          background-image: url("${logodir}/power.png");
      }
      #shutdown:focus {
          background-image: url("${logodir}/power-hover.png");
      }

      #reboot {
          background-image: url("${logodir}/restart.png");
      }
      #reboot:focus {
          background-image: url("${logodir}/restart-hover.png");
      }
    '';
    # ---

    # [button actions]
    layout = [
      {
        label = "lock";
        action = "swaylock -f -i ~/.wallpapers/lockscreen.jpg";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
    ];
  };
}
