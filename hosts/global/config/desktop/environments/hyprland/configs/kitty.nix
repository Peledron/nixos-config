{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;

    theme = "Nord"; # can be any from https://github.com/kovidgoyal/kitty-themes/tree/master/themes

    font = {
      name = "Ubuntu Nerd Font Mono";
      size = 14.0;
    };
    shellIntegration.mode = "disabled"; #"no-sudo"; # fixes issues with doasnot understanding kitties TERMINFO variable (since we are using doas-sudo-shim)

    settings = {
      # [advanced]
      # --> set shell program to launch on start
      shell = "fish"; # . means default user shell

      # [cursor]
      # --> The cursor shape can be one of (block, beam, underline)
      cursor_shape = "block";

      # --> The interval (in seconds) at which to blink the cursor.
      cursor_blink_interval = "0.5"; # Set to zero to disable blinking.

      # --> Stop blinking cursor after the specified number of seconds of keyboard inactivity.
      cursor_stop_blinking_after = "15.0"; # Set to zero or a negative number to never stop blinking.

      # [history]
      # --> Number of lines of history to keep in memory for scrolling back
      scrollback_lines = 99999;

      # --> Program with which to view scrollback in a new window.
      # The scrollback buffer is passed as STDIN to this program.
      # If you change it, make sure the program you use can handle ANSI escape sequences for colors and text formatting.
      scrollback_pager = "less +G -R";

      # [mouse]
      # -->  Wheel scroll multiplier (modify the amount scrolled by the mouse wheel)
      wheel_scroll_multiplier = "5.0";

      # --> The interval between successive clicks to detect double/triple clicks (in seconds)
      click_interval = "0.5";

      # --> Characters considered part of a word when double clicking.
      # In addition to these characters any character that is marked as an alpha-numeric character in the unicode database will be matched.
      select_by_word_characters = ":@-./_~?&=%+#";

      # --> Hide mouse cursor after the specified number of seconds of the mouse not being used.
      # Set to zero or a negative number to disable mouse cursor hiding.
      mouse_hide_wait = "0.0";

      # [layouts]
      # --> The enabled window layouts.
      # A comma separated list of layout names. The special value * means all layouts. The first listed layout will be used as the startup layout.
      # For a list of available layouts, see https://github.com/kovidgoyal/kitty/tree/master/kitty/layout
      enabled_layouts = "*";

      # [window]
      # --> the initial window size.
      # If enabled, the window size will be remembered so that new instances of kitty will have the same size as the previous instance.
      # If disabled, the window will initially have size configured by initial_window_width/height, in pixels.
      remember_window_size = "no";
      initial_window_width = 640;
      initial_window_height = 400;

      # --> The width (in pts) of window borders.
      # Will be rounded to the nearest number of pixels based on screen resolution.
      window_border_width = 0;
      window_margin_width = 15;

      # --> Delay (in milliseconds) between screen updates.
      # Decreasing it, increases fps at the cost of more CPU usage.
      # The default value (10) yields ~100fps which is more than sufficient for most uses.
      repaint_delay = 7; # 144fps would be about 6.9

      # --> Delay (in milliseconds) before input from the program running in the terminal is processed.
      # Note that decreasing it will increase responsiveness, but also increase CPU usage and might cause flicker in full screen programs that redraw the entire screen on each loop, because kitty is so fast that partial screen updates will be drawn.
      input_delay = 3;

      # --> Visual bell duration.
      # Flash the screen when a bell occurs for the specified number of seconds.
      visual_bell_duration = "0.0"; # Set to zero to disable.

      # --> Enable/disable the audio bell.
      # Useful in environments that require silence.
      enable_audio_bell = "no";

      # [URL handling]
      # --> The modifier keys to press when clicking with the mouse on URLs to open the URL
      open_url_modifiers = "ctrl";

      # --> The program with which to open URLs that are clicked on.
      # The special value "default" means to use the operating system's default URL handler.
      open_url_with = "default";

      # [tab bar]
      # --> placement of the tab-bar
      # can be either top or bottom
      tab_bar_edge = "top";

      # --> look of the tab-bar
      # can be "fade" (the edges fade into one-another), " slant" (tabs are seperated like files /), "seperator" (configured with tab_seperator), "powerline" (fancy seperator, can be configured with tab_powerline_style), "custom" (complex configuration with python), "hidden" (hides the tab bar)
      tab_bar_style = "powerline";

      # --> tab powerline style configuration
      # can be either "angled", "round" or "slanted"
      tab_powerline_style = "round";

      # -->  symbol to show when an active process is running within a tab
      tab_activity_symbol = "󱖏 ";

      # [session]
      # --> The value of the TERM environment variable to set
      term = "xterm-kitty";

      # [color scheme]
      # --> set background opacity
      # ranges from 0 for fully transparent to 1
      background_opacity = "0.7";
    };
    keybindings = {
      /*
      For a list of key names, see: http://www.glfw.org/docs/latest/group__keys.html
      For a list of modifier names, see: http://www.glfw.org/docs/latest/group__mods.html
      You can use the special action no_op to unmap a keyboard shortcut that is assigned in the default configuration.
      */

      # [Clipboard]
      "ctrl+v" = "paste_from_clipboard";
      "ctrl+shift+v" = "paste_from_selection";
      "ctrl+c" = "copy_and_clear_or_interrupt"; # Copy the selected text from the active window to the clipboard and clear selection, if no selection, send SIGINT
      "shift+insert" = "paste_from_selection";

      # [Scrolling]
      "ctrl+shift+up" = "scroll_line_up";
      "ctrl+shift+down" = "scroll_line_down";
      "ctrl+shift+k" = "scroll_line_up";
      "ctrl+shift+j" = "scroll_line_down";
      "ctrl+shift+page_up" = "scroll_page_up";
      "ctrl+shift+page_down" = "scroll_page_down";
      "ctrl+shift+home" = "scroll_home";
      "ctrl+shift+end" = "scroll_end";
      "ctrl+shift+h" = "show_scrollback";

      # [Window management]
      "ctrl+n" = "new_os_window";
      "ctrl+x" = "close_window";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+1" = "first_window";
      "ctrl+shift+2" = "second_window";
      "ctrl+shift+3" = "third_window";
      "ctrl+shift+4" = "fourth_window";
      "ctrl+shift+5" = "fifth_window";
      "ctrl+shift+6" = "sixth_window";
      "ctrl+shift+7" = "seventh_window";
      "ctrl+shift+8" = "eighth_window";
      "ctrl+shift+9" = "ninth_window";
      "ctrl+shift+0" = "tenth_window";

      # [Tab management]
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";

      # [Miscellaneous]
      "ctrl+add" = "increase_font_size";
      "ctrl+subtract" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
    };
  };
}
