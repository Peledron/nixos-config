{...}: {
 programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-8ae111f7-d269-4c78-8b56-a97e0cf89ef9" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = "Meta+Alt+L";
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = ["Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku,Touchpad Toggle" "Meta+Ctrl+Zenkaku Hankaku"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute,Microphone Mute" "Meta+Volume Mute,Mute Microphone"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Halt Without Confirmation" = "none,,Shut Down Without Confirmation";
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver,Meta+L" "Screensaver,Lock Session"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "ksmserver"."Log Out Without Confirmation" = "none,,Log Out Without Confirmation";
      "ksmserver"."Reboot" = "none,,Reboot";
      "ksmserver"."Reboot Without Confirmation" = "none,,Reboot Without Confirmation";
      "ksmserver"."Shut Down" = "none,,Shut Down";
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = "none,,Decrease Opacity of Active Window by 5%";
      "kwin"."Edit Tiles" = "none,Meta+T,Toggle Tiles Editor";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C),Ctrl+F10" "Launch (C),Toggle Present Windows (All desktops)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "Meta+G";
      "kwin"."Increase Opacity" = "none,,Increase Opacity of Active Window by 5%";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."KrohnkiteBTreeLayout" = [ ];
      "kwin"."KrohnkiteDecrease" = [ ];
      "kwin"."KrohnkiteFloatAll" = [ ];
      "kwin"."KrohnkiteFloatingLayout" = [ ];
      "kwin"."KrohnkiteFocusDown" = [ ];
      "kwin"."KrohnkiteFocusLeft" = [ ];
      "kwin"."KrohnkiteFocusNext" = [ ];
      "kwin"."KrohnkiteFocusPrev" = "Meta+\\,,none,Krohnkite: Focus Previous";
      "kwin"."KrohnkiteFocusRight" = [ ];
      "kwin"."KrohnkiteFocusUp" = [ ];
      "kwin"."KrohnkiteGrowHeight" = "Meta+Ctrl+Up,none,Krohnkite: Grow Height";
      "kwin"."KrohnkiteIncrease" = "Meta+I,none,Krohnkite: Increase";
      "kwin"."KrohnkiteMonocleLayout" = [ ];
      "kwin"."KrohnkiteNextLayout" = [ ];
      "kwin"."KrohnkitePreviousLayout" = [ ];
      "kwin"."KrohnkiteQuarterLayout" = [ ];
      "kwin"."KrohnkiteRotate" = [ ];
      "kwin"."KrohnkiteRotatePart" = [ ];
      "kwin"."KrohnkiteSetMaster" = "Meta+Return,none,Krohnkite: Set master";
      "kwin"."KrohnkiteShiftDown" = [ ];
      "kwin"."KrohnkiteShiftLeft" = [ ];
      "kwin"."KrohnkiteShiftRight" = [ ];
      "kwin"."KrohnkiteShiftUp" = [ ];
      "kwin"."KrohnkiteShrinkHeight" = "Meta+Ctrl+Down,none,Krohnkite: Shrink Height";
      "kwin"."KrohnkiteShrinkWidth" = "Meta+Ctrl+Left,none,Krohnkite: Shrink Width";
      "kwin"."KrohnkiteSpiralLayout" = [ ];
      "kwin"."KrohnkiteSpreadLayout" = [ ];
      "kwin"."KrohnkiteStackedLayout" = [ ];
      "kwin"."KrohnkiteStairLayout" = [ ];
      "kwin"."KrohnkiteTileLayout" = "Meta+T,none,Krohnkite: Tile Layout";
      "kwin"."KrohnkiteToggleFloat" = [ ];
      "kwin"."KrohnkiteTreeColumnLayout" = [ ];
      "kwin"."KrohnkitegrowWidth" = "Meta+Ctrl+Right,none,Krohnkite: Grow Width";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = "none,Meta+W,Toggle Overview";
      "kwin"."PoloniumCycleEngine" = "Meta+|,none,Polonium: Cycle Engine";
      "kwin"."PoloniumFocusAbove" = "Meta+K,none,Polonium: Focus Above";
      "kwin"."PoloniumFocusBelow" = "Meta+J,none,Polonium: Focus Below";
      "kwin"."PoloniumFocusLeft" = "Meta+H,none,Polonium: Focus Left";
      "kwin"."PoloniumFocusRight" = [ ];
      "kwin"."PoloniumInsertAbove" = [ ];
      "kwin"."PoloniumInsertBelow" = [ ];
      "kwin"."PoloniumInsertLeft" = [ ];
      "kwin"."PoloniumInsertRight" = [ ];
      "kwin"."PoloniumOpenSettings" = "Meta+\\\\,none,Polonium: Open Settings Dialog";
      "kwin"."PoloniumResizeAbove" = [ ];
      "kwin"."PoloniumResizeBelow" = [ ];
      "kwin"."PoloniumResizeLeft" = [ ];
      "kwin"."PoloniumResizeRight" = [ ];
      "kwin"."PoloniumRetileWindow" = [ ];
      "kwin"."PoloniumSwitchBTree" = [ ];
      "kwin"."PoloniumSwitchHalf" = [ ];
      "kwin"."PoloniumSwitchKwin" = [ ];
      "kwin"."PoloniumSwitchMonocle" = [ ];
      "kwin"."PoloniumSwitchThreeColumn" = [ ];
      "kwin"."Setup Window Shortcut" = "none,,Setup Window Shortcut";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."Switch One Desktop Down" = "none,Meta+Ctrl+Down,Switch One Desktop Down";
      "kwin"."Switch One Desktop Up" = "none,Meta+Ctrl+Up,Switch One Desktop Up";
      "kwin"."Switch One Desktop to the Left" = "none,Meta+Ctrl+Left,Switch One Desktop to the Left";
      "kwin"."Switch One Desktop to the Right" = "none,Meta+Ctrl+Right,Switch One Desktop to the Right";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = ["Ctrl+F1" "Meta+1,Ctrl+F1,Switch to Desktop 1"];
      "kwin"."Switch to Desktop 10" = "none,,Switch to Desktop 10";
      "kwin"."Switch to Desktop 11" = "none,,Switch to Desktop 11";
      "kwin"."Switch to Desktop 12" = "none,,Switch to Desktop 12";
      "kwin"."Switch to Desktop 13" = "none,,Switch to Desktop 13";
      "kwin"."Switch to Desktop 14" = "none,,Switch to Desktop 14";
      "kwin"."Switch to Desktop 15" = "none,,Switch to Desktop 15";
      "kwin"."Switch to Desktop 16" = "none,,Switch to Desktop 16";
      "kwin"."Switch to Desktop 17" = "none,,Switch to Desktop 17";
      "kwin"."Switch to Desktop 18" = "none,,Switch to Desktop 18";
      "kwin"."Switch to Desktop 19" = "none,,Switch to Desktop 19";
      "kwin"."Switch to Desktop 2" = ["Meta+2" "Ctrl+F2,Ctrl+F2,Switch to Desktop 2"];
      "kwin"."Switch to Desktop 20" = "none,,Switch to Desktop 20";
      "kwin"."Switch to Desktop 3" = ["Ctrl+F3" "Meta+3,Ctrl+F3,Switch to Desktop 3"];
      "kwin"."Switch to Desktop 4" = ["Ctrl+F4" "Meta+4,Ctrl+F4,Switch to Desktop 4"];
      "kwin"."Switch to Desktop 5" = "Meta+5,,Switch to Desktop 5";
      "kwin"."Switch to Desktop 6" = "Meta+6,,Switch to Desktop 6";
      "kwin"."Switch to Desktop 7" = "Meta+7,,Switch to Desktop 7";
      "kwin"."Switch to Desktop 8" = "Meta+8,,Switch to Desktop 8";
      "kwin"."Switch to Desktop 9" = "Meta+9,,Switch to Desktop 9";
      "kwin"."Switch to Next Desktop" = "none,,Switch to Next Desktop";
      "kwin"."Switch to Next Screen" = "none,,Switch to Next Screen";
      "kwin"."Switch to Previous Desktop" = "none,,Switch to Previous Desktop";
      "kwin"."Switch to Previous Screen" = "none,,Switch to Previous Screen";
      "kwin"."Switch to Screen 0" = "none,,Switch to Screen 0";
      "kwin"."Switch to Screen 1" = "none,,Switch to Screen 1";
      "kwin"."Switch to Screen 2" = "none,,Switch to Screen 2";
      "kwin"."Switch to Screen 3" = "none,,Switch to Screen 3";
      "kwin"."Switch to Screen 4" = "none,,Switch to Screen 4";
      "kwin"."Switch to Screen 5" = "none,,Switch to Screen 5";
      "kwin"."Switch to Screen 6" = "none,,Switch to Screen 6";
      "kwin"."Switch to Screen 7" = "none,,Switch to Screen 7";
      "kwin"."Switch to Screen Above" = "none,,Switch to Screen Above";
      "kwin"."Switch to Screen Below" = "none,,Switch to Screen Below";
      "kwin"."Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
      "kwin"."Switch to Screen to the Right" = "none,,Switch to Screen to the Right";
      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows (Reverse)" = "Alt+Shift+Tab";
      "kwin"."Walk Through Windows Alternative" = "none,,Walk Through Windows Alternative";
      "kwin"."Walk Through Windows Alternative (Reverse)" = "none,,Walk Through Windows Alternative (Reverse)";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Walk Through Windows of Current Application Alternative" = "none,,Walk Through Windows of Current Application Alternative";
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = "none,,Walk Through Windows of Current Application Alternative (Reverse)";
      "kwin"."Window Above Other Windows" = "none,,Keep Window Above Others";
      "kwin"."Window Below Other Windows" = "none,,Keep Window Below Others";
      "kwin"."Window Close" = ["Meta+X" "Alt+F4,Alt+F4,Close Window"];
      "kwin"."Window Fullscreen" = "Meta+F,,Make Window Fullscreen";
      "kwin"."Window Grow Horizontal" = "none,,Expand Window Horizontally";
      "kwin"."Window Grow Vertical" = "none,,Expand Window Vertically";
      "kwin"."Window Lower" = "none,,Lower Window";
      "kwin"."Window Maximize" = ["Meta+M" "Meta+PgUp,Meta+PgUp,Maximize Window"];
      "kwin"."Window Maximize Horizontal" = "none,,Maximize Window Horizontally";
      "kwin"."Window Maximize Vertical" = "none,,Maximize Window Vertically";
      "kwin"."Window Minimize" = ["Meta+PgDown" "Meta+N,Meta+PgDown,Minimize Window"];
      "kwin"."Window Move" = "none,,Move Window";
      "kwin"."Window Move Center" = "none,,Move Window to the Center";
      "kwin"."Window No Border" = "none,,Toggle Window Titlebar and Frame";
      "kwin"."Window On All Desktops" = "none,,Keep Window on All Desktops";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = "none,,Move Window One Screen Down";
      "kwin"."Window One Screen Up" = "none,,Move Window One Screen Up";
      "kwin"."Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
      "kwin"."Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "none,,Move Window Down";
      "kwin"."Window Pack Left" = "none,,Move Window Left";
      "kwin"."Window Pack Right" = "none,,Move Window Right";
      "kwin"."Window Pack Up" = "none,,Move Window Up";
      "kwin"."Window Quick Tile Bottom" = "none,Meta+Down,Quick Tile Window to the Bottom";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "none,Meta+Left,Quick Tile Window to the Left";
      "kwin"."Window Quick Tile Right" = "none,Meta+Right,Quick Tile Window to the Right";
      "kwin"."Window Quick Tile Top" = "none,Meta+Up,Quick Tile Window to the Top";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
      "kwin"."Window Raise" = "none,,Raise Window";
      "kwin"."Window Resize" = "none,,Resize Window";
      "kwin"."Window Shade" = "none,,Shade Window";
      "kwin"."Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
      "kwin"."Window Shrink Vertical" = "none,,Shrink Window Vertically";
      "kwin"."Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
      "kwin"."Window to Desktop 10" = "none,,Window to Desktop 10";
      "kwin"."Window to Desktop 11" = "none,,Window to Desktop 11";
      "kwin"."Window to Desktop 12" = "none,,Window to Desktop 12";
      "kwin"."Window to Desktop 13" = "none,,Window to Desktop 13";
      "kwin"."Window to Desktop 14" = "none,,Window to Desktop 14";
      "kwin"."Window to Desktop 15" = "none,,Window to Desktop 15";
      "kwin"."Window to Desktop 16" = "none,,Window to Desktop 16";
      "kwin"."Window to Desktop 17" = "none,,Window to Desktop 17";
      "kwin"."Window to Desktop 18" = "none,,Window to Desktop 18";
      "kwin"."Window to Desktop 19" = "none,,Window to Desktop 19";
      "kwin"."Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
      "kwin"."Window to Desktop 20" = "none,,Window to Desktop 20";
      "kwin"."Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
      "kwin"."Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
      "kwin"."Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
      "kwin"."Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
      "kwin"."Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
      "kwin"."Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
      "kwin"."Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
      "kwin"."Window to Next Desktop" = "none,,Window to Next Desktop";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = "none,,Window to Previous Desktop";
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."Window to Screen 0" = "Meta+Ctrl+1,,Move Window to Screen 0";
      "kwin"."Window to Screen 1" = "Meta+Ctrl+2,,Move Window to Screen 1";
      "kwin"."Window to Screen 2" = "Meta+Ctrl+3,,Move Window to Screen 2";
      "kwin"."Window to Screen 3" = "Meta+Ctrl+4,,Move Window to Screen 3";
      "kwin"."Window to Screen 4" = "none,,Move Window to Screen 4";
      "kwin"."Window to Screen 5" = "none,,Move Window to Screen 5";
      "kwin"."Window to Screen 6" = "none,,Move Window to Screen 6";
      "kwin"."Window to Screen 7" = "none,,Move Window to Screen 7";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+=,Meta++" "Meta+=,Zoom In"];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = "none,,Media volume down";
      "mediacontrol"."mediavolumeup" = "none,,Media volume up";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = "none,,Play media playback";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = ["Meta+Launch (1)" "Battery" "Meta+B,Battery" "Meta+B,Switch Power Profile"];
      "plasmashell"."activate task manager entry 1" = "none,Meta+1,Activate Task Manager Entry 1";
      "plasmashell"."activate task manager entry 10" = "none,Meta+0,Activate Task Manager Entry 10";
      "plasmashell"."activate task manager entry 2" = "none,Meta+2,Activate Task Manager Entry 2";
      "plasmashell"."activate task manager entry 3" = "none,Meta+3,Activate Task Manager Entry 3";
      "plasmashell"."activate task manager entry 4" = "none,Meta+4,Activate Task Manager Entry 4";
      "plasmashell"."activate task manager entry 5" = "none,Meta+5,Activate Task Manager Entry 5";
      "plasmashell"."activate task manager entry 6" = "none,Meta+6,Activate Task Manager Entry 6";
      "plasmashell"."activate task manager entry 7" = "none,Meta+7,Activate Task Manager Entry 7";
      "plasmashell"."activate task manager entry 8" = "none,Meta+8,Activate Task Manager Entry 8";
      "plasmashell"."activate task manager entry 9" = "none,Meta+9,Activate Task Manager Entry 9";
      "plasmashell"."clear-history" = "none,,Clear Clipboard History";
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = "none,,Next History Item";
      "plasmashell"."cyclePrevAction" = "none,,Previous History Item";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A,none,Walk through activities";
      "plasmashell"."previous activity" = "Meta+Shift+A,none,Walk through activities (Reverse)";
      "plasmashell"."repeat_action" = "none,Meta+Ctrl+R,Manually Invoke Action on Current Clipboard";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = "none,,Show Barcode…";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = "none,,Switch to Next Activity";
      "plasmashell"."switch to previous activity" = "none,,Switch to Previous Activity";
      "plasmashell"."toggle do not disturb" = "none,,Toggle do not disturb";
      "services/firefox.desktop"."new-window" = "Meta+W";
      "services/org.kde.konsole.desktop"."_launch" = "Meta+C";
      "services/org.kde.krunner.desktop"."_launch" = "Meta+Space";
      "services/org.kde.plasma-systemmonitor.desktop"."_launch" = [ ];
      "services/org.kde.spectacle.desktop"."_launch" = "Meta+Shift+S";
      "services/systemsettings.desktop"."_launch" = ["Tools" "Meta+Shift+Esc"];
    };
    configFile = {
      "baloofilerc"."General"."dbVersion" = 2;
      "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version" = 9;
      "baloofilerc"."General"."exclude folders[$e]" = "$HOME/Data/Downloads/,$HOME/Data/Windows/,$HOME/Games/";
      "dolphinrc"."DetailsMode"."PreviewSize" = 16;
      "dolphinrc"."General"."ViewPropsTimestamp" = "2024,8,28,20,27,52.906";
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "kactivitymanagerdrc"."activities"."8ae111f7-d269-4c78-8b56-a97e0cf89ef9" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "8ae111f7-d269-4c78-8b56-a97e0cf89ef9";
      "kcminputrc"."Libinput/1133/49734/Logitech G300s Optical Gaming Mouse"."PointerAccelerationProfile" = 1;
      "kcminputrc"."Libinput/13364/929/Keychron Keychron V10 Mouse"."PointerAcceleration" = 0.250;
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."DirSelect Dialog"."DirSelectDialog Size" = "851,512";
      "kdeglobals"."General"."XftAntialias" = true;
      "kdeglobals"."General"."XftHintStyle" = "hintslight";
      "kdeglobals"."General"."XftSubPixel" = "rgb";
      "kdeglobals"."General"."fixed" = "UbuntuMono Nerd Font,14,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."font" = "Ubuntu Nerd Font Med,13,-1,5,500,0,0,0,0,0,0,0,0,0,0,1,Regular";
      "kdeglobals"."General"."menuFont" = "Ubuntu Nerd Font Med,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."smallestReadableFont" = "Ubuntu Nerd Font Med,11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."General"."toolBarFont" = "Ubuntu Nerd Font Med,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."KDE"."AnimationDurationFactor" = 0.35355339059327373;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 177;
      "kdeglobals"."KFileDialog Settings"."View Style" = "Simple";
      "kdeglobals"."KShortcutsDialog Settings"."Dialog Size" = "600,480";
      "kdeglobals"."Shortcuts"."AboutApp" = "";
      "kdeglobals"."Shortcuts"."AboutKDE" = "";
      "kdeglobals"."Shortcuts"."Clear" = "";
      "kdeglobals"."Shortcuts"."ConfigureNotifications" = "";
      "kdeglobals"."Shortcuts"."ConfigureToolbars" = "";
      "kdeglobals"."Shortcuts"."Donate" = "";
      "kdeglobals"."Shortcuts"."EditBookmarks" = "";
      "kdeglobals"."Shortcuts"."FitToHeight" = "";
      "kdeglobals"."Shortcuts"."FitToPage" = "";
      "kdeglobals"."Shortcuts"."FitToWidth" = "";
      "kdeglobals"."Shortcuts"."Goto" = "";
      "kdeglobals"."Shortcuts"."GotoPage" = "";
      "kdeglobals"."Shortcuts"."Mail" = "";
      "kdeglobals"."Shortcuts"."OpenRecent" = "";
      "kdeglobals"."Shortcuts"."PrintPreview" = "";
      "kdeglobals"."Shortcuts"."ReportBug" = "";
      "kdeglobals"."Shortcuts"."Revert" = "";
      "kdeglobals"."Shortcuts"."ShowStatusbar" = "";
      "kdeglobals"."Shortcuts"."ShowToolbar" = "";
      "kdeglobals"."Shortcuts"."Spelling" = "";
      "kdeglobals"."Shortcuts"."SwitchApplicationLanguage" = "";
      "kdeglobals"."Shortcuts"."Zoom" = "";
      "kdeglobals"."WM"."activeBackground" = "24,24,24";
      "kdeglobals"."WM"."activeBlend" = "255,148,112";
      "kdeglobals"."WM"."activeFont" = "Ubuntu Nerd Font Med,13,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
      "kdeglobals"."WM"."activeForeground" = "255,255,255";
      "kdeglobals"."WM"."inactiveBackground" = "24,24,24";
      "kdeglobals"."WM"."inactiveBlend" = "136,136,136";
      "kdeglobals"."WM"."inactiveForeground" = "255,255,255";
      "krunnerrc"."General"."FreeFloating" = true;
      "krunnerrc"."Plugins"."baloosearchEnabled" = true;
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."Image" = "/home/pengolodh/Data/Pictures/wallpapers/ultrawide/nature/1g3ynO0.jpg";
      "kscreenlockerrc"."Greeter/Wallpaper/org.kde.image/General"."PreviewImage" = "/home/pengolodh/Data/Pictures/wallpapers/ultrawide/nature/1g3ynO0.jpg";
      "ksmserverrc"."General"."confirmLogout" = false;
      "ksmserverrc"."General"."loginMode" = "emptySession";
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Id_1" = "c828b5c3-edee-4520-b6d3-9f6ba21657ea";
      "kwinrc"."Desktops"."Id_2" = "b9b6c071-2c53-4cb1-9e05-778b83d72b04";
      "kwinrc"."Desktops"."Id_3" = "af3544ac-ddda-4e52-a892-76f515a7c477";
      "kwinrc"."Desktops"."Id_4" = "38b0f99f-64d9-4581-bf37-fecac452761d";
      "kwinrc"."Desktops"."Id_5" = "4779d0e4-9759-4af1-ab07-e68b73a4dad5";
      "kwinrc"."Desktops"."Number" = 5;
      "kwinrc"."Desktops"."Rows" = 5;
      "kwinrc"."Effect-overview"."BorderActivate" = 9;
      "kwinrc"."Plugins"."krohnkiteEnabled" = true;
      "kwinrc"."Plugins"."poloniumEnabled" = true;
      "kwinrc"."Script-krohnkite"."enableBTreeLayout" = true;
      "kwinrc"."Script-krohnkite"."maximizeSoleTile" = true;
      "kwinrc"."Script-krohnkite"."noTileBorder" = true;
      "kwinrc"."Script-krohnkite"."screenGapBottom" = 4;
      "kwinrc"."Script-krohnkite"."screenGapLeft" = 4;
      "kwinrc"."Script-krohnkite"."screenGapRight" = 4;
      "kwinrc"."Script-krohnkite"."screenGapTop" = 4;
      "kwinrc"."Script-krohnkite"."tileLayoutGap" = 4;
      "kwinrc"."Script-polonium"."InsertionPoint" = 1;
      "kwinrc"."Script-polonium"."MaximizeSingle" = true;
      "kwinrc"."TabBox"."LayoutName" = "compact";
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling/127adf10-2550-5eb1-a2ca-f6a343d712c6"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[]}";
      "kwinrc"."Tiling/53f1b73b-523e-5758-9bd3-8f53881e21ce"."tiles" = "{\"layoutDirection\":\"horizontal\",\"tiles\":[]}";
      "kwinrc"."Xwayland"."Scale" = 1;
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasma-localerc"."Formats"."LC_ADDRESS" = "nl_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_MONETARY" = "en_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_NAME" = "nl_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_NUMERIC" = "en_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_PAPER" = "en_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_TELEPHONE" = "nl_BE.UTF-8";
      "plasma-localerc"."Formats"."LC_TIME" = "en_BE.UTF-8";
      "plasmanotifyrc"."Applications/vesktop"."Seen" = true;
      "plasmarc"."Wallpapers"."usersWallpapers" = "/home/pengolodh/Data/Pictures/wallpapers/ultrawide/nature/NZrct4m.jpg";
    };
  };
}
