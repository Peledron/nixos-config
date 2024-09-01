{config, ...}: let
  lockscreen = ./non-nix/lockscreen.jpg;
in {
  programs.plasma = {
    # see all options on https://nix-community.github.io/plasma-manager/options.xhtml
    enable = true;
    overrideConfig = true; # makes plasma fully declerative, it destroys most config files each generation so you can lose config if not properly defined here
    fonts = {
      general = {
        family = config.stylix.fonts.sansSerif.name;
        pointSize = config.stylix.fonts.sizes.applications;
      };
      menu = {
        family = config.stylix.fonts.sansSerif.name;
        pointSize = config.stylix.fonts.sizes.desktop;
      };
      toolbar = {
        family = config.stylix.fonts.sansSerif.name;
        pointSize = config.stylix.fonts.sizes.desktop;
      };
      windowTitle = {
        family = config.stylix.fonts.sansSerif.name;
        pointSize = config.stylix.fonts.sizes.desktop;
      };
      small = {
        family = config.stylix.fonts.sansSerif.name;
        pointSize = 11;
      };
      fixedWidth = {
        family = config.stylix.fonts.monospace.name;
        pointSize = config.stylix.fonts.sizes.terminal;
        weight = "bold";
      };
    };
    workspace = {
      clickItemTo = "select";
      lookAndFeel = "stylix";
      soundTheme = "Ocean";
      cursor = {
        theme = config.stylix.cursor.name;
        size = config.stylix.cursor.size;
      };
      iconTheme = config.gtk.iconTheme.name;
      splashScreen.theme = "None"; # None disables the splash screen
    };
    panels = [
      {
        location = "left";
        height = 28;
        widgets = [
          # see ~/.config/plasma-org.kde.plasma.desktop-appletsrc for all configured widgets and their options
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
                alphaSort = true;
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.diskactivity"
          "org.kde.plasma.marginsseparator"
          "org.kde.plasma.systemmonitor.net"
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.systemmonitor.memory";
            config.Appearance.chartFace = "org.kde.ksysguard.linechart";
          }
          "org.kde.plasma.marginsseparator"
          {
            name = "org.kde.plasma.systemmonitor.cpucore";
            config.Appearance.chartFace = "org.kde.ksysguard.horizontalbars";
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.volume"
                "org.kde.plasma.clipboard"
                "Applications/vesktop"
              ];
            };
          }
          "split-clock"
        ];
      }
    ];

    kscreenlocker = {
      appearance = {
        showMediaControls = true;
        alwaysShowClock = true;
        wallpaper = lockscreen;
      };
      timeout = 25; # time in minutes
    };
    kwin = {
      effects = {
        # anim
        minimization.animation = "squash";
        desktopSwitching.animation = "fade";
        windowOpenClose.animation = "fade";
        #fallApart.enable = true; # makes closed windows fall appart
        # other
        dimAdminMode.enable = true;
      };
      virtualDesktops = {
        number = 5;
        rows = 5;
        # as we are using a vertical panel (see above) to save height I need to use a vertical layout of  virtual desktops, otherwise the switcher does not work
      };
    };
    spectacle.shortcuts.captureRectangularRegion = "Print";
    shortcuts = {
      kmix = {
        "increase_volume" = "Volume Up";
        "decrease_volume" = "Volume Down";
        "increase_volume_small" = "Shift+Volume Up";
        "decrease_volume_small" = "Shift+Volume Down";
        "mute" = "Volume Mute";

        "increase_microphone_volume" = ["Meta+Volume Up" "Microphone Volume Up"];
        "decrease_microphone_volume" = ["Meta+Volume Down" "Microphone Volume Down"];
        "mic_mute" = ["Meta+Volume Mute" "Microphone Mute" "Mute Microphone"];
      };

      ksmserver = {
        "Log Out" = "Meta+Esc";
      };
      kwin = {
        "Window Close" = ["Meta+X" "Alt+F4" "Close Window"];
        "Kill Window" = "Meta+Ctrl+X";

        "KrohnkiteToggleFloat" = "Meta+Shift+F";
        "KrohnkiteBTreeLayout" = "Meta+T";
        "KrohnkiteTreeColumnLayout" = "Meta+Shift+T";

        "KrohnkiteNextLayout" = "Meta+\\";
        "KrohnkitePreviousLayout" = "Meta+]";

        "KrohnkiteShiftDown" = "Meta+Down";
        "KrohnkiteShiftLeft" = "Meta+Left";
        "KrohnkiteShiftRight" = "Meta+Right";
        "KrohnkiteShiftUp" = "Meta+Up";

        "KrohnkiteGrowHeight" = ["Meta+Ctrl+Up" "Krohnkite: Grow Height"];
        "KrohnkiteShrinkHeight" = ["Meta+Ctrl+Down" "Krohnkite: Shrink Height"];
        "KrohnkitegrowWidth" = ["Meta+Ctrl+Right" "Krohnkite: Grow Width"];
        "KrohnkiteShrinkWidth" = ["Meta+Ctrl+Left" "Krohnkite: Shrink Width"];

        "Switch to Desktop 1" = ["Meta+1" "Switch to Desktop 1"];
        "Switch to Desktop 2" = ["Meta+2" "Switch to Desktop 2"];
        "Switch to Desktop 3" = ["Meta+3" "Switch to Desktop 3"];
        "Switch to Desktop 4" = ["Meta+4" "Switch to Desktop 4"];
        "Switch to Desktop 5" = ["Meta+5" "Switch to Desktop 5"];
        "Switch to Desktop 6" = ["Meta+6" "Switch to Desktop 6"];
        "Switch to Desktop 7" = ["Meta+7" "Switch to Desktop 7"];
        "Switch to Desktop 8" = ["Meta+8" "Switch to Desktop 8"];
        "Switch to Desktop 9" = ["Meta+9" "Switch to Desktop 9"];

        "Window to Desktop 1" = ["Meta+!" "Window to Desktop 1"];
        "Window to Desktop 2" = ["Meta+@" "Window to Desktop 2"];
        "Window to Desktop 3" = ["Meta+#" "Window to Desktop 3"];
        "Window to Desktop 4" = ["Meta+$" "Window to Desktop 4"];
        "Window to Desktop 5" = ["Meta+%" "Window to Desktop 5"];
        "Window to Desktop 6" = ["Meta+^" "Window to Desktop 6"];
        "Window to Desktop 7" = ["Meta+&" "Window to Desktop 7"];
        "Window to Desktop 8" = ["Meta+*" "Window to Desktop 8"];
        "Window to Desktop 9" = ["Meta+(" "Window to Desktop 9"];

        "Switch to Screen 0" = ["Meta+Ctrl+1" "Switch to Screen 0"];
        "Switch to Screen 1" = ["Meta+Ctrl+2" "Switch to Screen 1"];
        "Switch to Screen 2" = ["Meta+Ctrl+3" "Switch to Screen 2"];
        "Switch to Screen 3" = ["Meta+Ctrl+4" "Switch to Screen 3"];
        "Switch to Screen 4" = ["Meta+Ctrl+5" "Switch to Screen 4"];
        "Switch to Screen 5" = ["Meta+Ctrl+6" "Switch to Screen 5"];
        "Switch to Screen 6" = ["Meta+Ctrl+7" "Switch to Screen 6"];
        "Switch to Screen 7" = ["Meta+Ctrl+8" "Switch to Screen 7"];

        "Window to Screen 0" = ["Meta+Ctrl+!" "Move Window to Screen 0"];
        "Window to Screen 1" = ["Meta+Ctrl+@" "Move Window to Screen 1"];
        "Window to Screen 2" = ["Meta+Ctrl+#" "Move Window to Screen 2"];
        "Window to Screen 3" = ["Meta+Ctrl+$" "Move Window to Screen 3"];
        "Window to Screen 4" = ["Meta+Ctrl+%" "Move Window to Screen 4"];
        "Window to Screen 5" = ["Meta+Ctrl+^" "Move Window to Screen 5"];
        "Window to Screen 6" = ["Meta+Ctrl+&" "Move Window to Screen 6"];
        "Window to Screen 7" = ["Meta+Ctrl+*" "Move Window to Screen 7"];

        "Window Fullscreen" = ["Meta+F" "Make Window Fullscreen"];
        "Window Maximize" = ["Meta+M" "Meta+PgUp" "Maximize Window"];
        "Window Minimize" = ["Meta+N" "Meta+PgDown" "Minimize Window"];
        "Window On All Desktops" = ["Meta+P" "Keep Window on All Desktops"];
      };
      mediacontrol = {
        "mediavolumedown" = "Media volume down";
        "mediavolumeup" = "Media volume up";
        "nextmedia" = "Media Next";
        "pausemedia" = "Media Pause";
        "playmedia" = "Play media playback";
        "playpausemedia" = "Media Play";
        "previousmedia" = "Media Previous";
        "stopmedia" = "Media Stop";
      };
      plasmashell = {
        "activate task manager entry 1" = "none";
        "activate task manager entry 2" = "none";
        "activate task manager entry 3" = "none";
        "activate task manager entry 4" = "none";
        "activate task manager entry 5" = "none";
        "activate task manager entry 6" = "none";
        "activate task manager entry 7" = "none";
        "activate task manager entry 8" = "none";
        "activate task manager entry 9" = "none";
        "activate task manager entry 10" = "none";
        "show-on-mouse-pos" = "Meta+V";
      };
      "services/firefox.desktop"."new-window" = "Meta+W";
      "services/org.kde.konsole.desktop"."_launch" = "Meta+C";
      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";
      "services/org.kde.spectacle.desktop"."_launch" = "Meta+Shift+S";
      "services/systemsettings.desktop"."_launch" = ["Tools" "Meta+Shift+Esc"];
    };
    configFile = {
      "baloofilerc"."General"."exclude folders[$e]" = "$HOME/Data/Downloads/,$HOME/Data/Windows/,$HOME/Games/";
      "dolphinrc"."DetailsMode"."PreviewSize" = 16;
      "kcminputrc"."Libinput/1133/49734/Logitech G300s Optical Gaming Mouse"."PointerAccelerationProfile" = 1;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      #"KDE"."AnimationDurationFactor" = "0.35355339059327373";
      "kwalletrc"."Wallet"."First Use" = false;

      kdeglobals = {
        "General"."XftAntialias" = true;
        "General"."XftHintStyle" = "hintslight";
        "General"."XftSubPixel" = "rgb";
      };
      krunnerrc = {
        "General"."FreeFloating" = true;
        "Plugins"."baloosearchEnabled" = true;
      };
      ksmserverrc = {
        "General"."confirmLogout" = true;
        "General"."loginMode" = "emptySession";
      };

      kwinrc = {
        "Plugins"."krohnkiteEnabled" = true;
        "Script-krohnkite"."enableBTreeLayout" = true;
        "Script-krohnkite"."maximizeSoleTile" = true;
        "Script-krohnkite"."noTileBorder" = true;
        "Script-krohnkite"."screenGapBottom" = 4;
        "Script-krohnkite"."screenGapLeft" = 4;
        "Script-krohnkite"."screenGapRight" = 4;
        "Script-krohnkite"."screenGapTop" = 4;
        "Script-krohnkite"."tileLayoutGap" = 4;
        "Effect-overview"."BorderActivate" = 9;
        "Tiling"."padding" = 4;
        "Xwayland"."Scale" = 1;
      };
    };
  };
}
