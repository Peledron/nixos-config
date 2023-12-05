{config, pkgs, ... }:
{
    programs.kitty = {
        enable = true;

        theme = "Nord"; # can be any from https://github.com/kovidgoyal/kitty-themes/tree/master/themes

        font = {
            name = "Ubuntu Nerd Font Mono";
            size = 11.0;
        };

        settings = {
            # [cursor]
            # --> The cursor shape can be one of (block, beam, underline)
                cursor_shape = "block";

            # --> The interval (in seconds) at which to blink the cursor.
                cursor_blink_interval = "0.5"; # Set to zero to disable blinking.

            # --> Stop blinking cursor after the specified number of seconds of keyboard inactivity.
                cursor_stop_blinking_after = "15.0"; # Set to zero or a negative number to never stop blinking.

            # [history]
            # --> Number of lines of history to keep in memory for scrolling back
                scrollback_lines = 2000;

            # --> Program with which to view scrollback in a new window.
                # The scrollback buffer is passed as STDIN to this program.
                # If you change it, make sure the program you use can handle ANSI escape sequences for colors and text formatting.
                scrollback_pager = "less +G -R";

            # [mouse]
            # -->  Wheel scroll multiplier (modify the amount scrolled by the mouse wheel)
                wheel_scroll_multiplier = "5.0";

            # --> The interval between successive clicks to detect double/triple clicks (in seconds)
                click_interval  = "0.5";

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
                repaint_delay = 10;

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
                open_url_modifiers = "ctrl+shift";

            # --> The program with which to open URLs that are clicked on.
                # The special value "default" means to use the operating system's default URL handler.
                open_url_with = "default";

            # [session]
            # --> The value of the TERM environment variable to set
                term = "xterm-kitty";

            # [colors]
            # --> foreground color
                foreground = "#c0b18b"; # Slightly desaturated orange
            # --> background color
                background = "#262626"; # Very dark gray (mostly black)
                background_opacity = "0.9";
            # --> The foreground for selections
                selection_foreground = "#2f2f2f"; # Very dark gray

            # --> The background for selections
                selection_background = "#d75f5f"; # Moderate red

            # --> The cursor color
                cursor = "#8fee96"; # Very soft lime green

            # --> active window border color
                active_border_color = "#ffffff"; # White

            # --> inactive window border color
                inactive_border_color = "#cccccc"; # Light gray

            # --> Tab-bar colors
                active_tab_foreground = "#000"; # Black
                active_tab_background = "#eee"; # Very light gray
                inactive_tab_foreground = "#444"; # Very dark gray
                inactive_tab_background = "#999";  # Dark gray

            # [terminal colors]
            # --> The 16 terminal colors. There are 8 basic colors, each color has a dull and bright version.
                # black
                color0 = "#2f2f2f";
                color8 = "#656565";

                # red
                color1 = "#d75f5f";
                color9 = "#d75f5f";

                # green
                color2 = "#d4d232";
                color10 = "#8fee96";

                # yellow
                color3 = "#af865a";
                color11 = "#cd950c";

                # blue
                color4 = "#22c3a1";
                color12 = "#22c3a1";

                # magenta
                color5 = "#775759";
                color13 = "#775759";

                # cyan
                color6 = "#84edb9";
                color14 = "#84edb9";

                # white
                color7 = "#c0b18b";
                color15 = "#d8d8d8";
            };
        keybindings = {
            /*
                For a list of key names, see: http://www.glfw.org/docs/latest/group__keys.html
                For a list of modifier names, see: http://www.glfw.org/docs/latest/group__mods.html
                You can use the special action no_op to unmap a keyboard shortcut that is assigned in the default configuration.
            */

            # [Clipboard]
                "super+v" = "paste_from_clipboard";
                "ctrl+shift+s" = "paste_from_selection";
                "super+c" = "copy_to_clipboard";
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
                "super+n" = "new_os_window";
                "super+w" = "close_window";
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
