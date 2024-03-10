{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.micro = lib.mkDefault {
    enable = false;
    settings = {
      autosave = 0; # autosave every 5 minutes
      colorscheme = "nord-16"; # defined below
    };
  };
  # define colorscheme referred to in programs.micro.settings.colorscheme
  # [nord]
  # -> from https://github.com/KiranWells/micro-nord-tc-colors
  ## nord-tc (no transparency)
  xdg.configFile = {
    "micro/colorschemes/nord-tc.micro".text = ''
      color-link default "#ECEFF4,#2E3440"
      color-link comment "#4C566A,#2E3440"
      color-link comment.bright "#6C768A,#2E3440"
      color-link identifier "#D8DEE9,#2E3440"
      color-link identifier.class "#8FBCBB,#2E3440"
      color-link identifier.macro "#B48EAD,#2E3440"
      color-link identifier.var "#D8DEE9,#2E3440"
      color-link constant "#8FBCBB,#2E3440"
      color-link constant.bool "#C3DEAC,#2E3440"
      color-link constant.bool.true "#C3DEAC,#2E3440"
      color-link constant.bool.false "#DF818A,#2E3440"
      color-link constant.number "#B48EAD,#2E3440"
      color-link constant.specialChar "#EBCB8B,#2E3440"
      color-link constant.string "#A3BE8C,#2E3440"
      color-link constant.string.url "#FBEBAB,#2E3440"
      color-link statement "#88C0D0,#2E3440"
      color-link symbol "#ECEFF4,#2E3440"
      color-link symbol.brackets "#6C768A,#2E3440"
      color-link symbol.operator "#81A1C1,#2E3440"
      color-link symbol.tag "#81A1C1,#2E3440"
      color-link preproc "#5E81AC,#2E3440"
      color-link preproc.shebang "#434C5E,#2E3440"
      color-link type "#8FBCBB,#2E3440"
      color-link type.keyword "#81A1C1,#2E3440"
      color-link special "#81A1C1,#2E3440"
      color-link underlined "#5E81AC,#3B4252"
      color-link error "bold #BF616A,#2E3440"
      color-link todo "bold #B48EAD,#2E3440"
      color-link statusline "#81A1C1,#3B4252"
      color-link tabbar "#E5E9F0,#3B4252"
      color-link indent-char "#4C566A,#2E3440"
      color-link line-number "#4C566A,#3B4252"
      color-link gutter-error "#BF616A,#4C566A"
      color-link gutter-warning "#EBCB8B,#4C566A"
      color-link cursor-line "#3B4252"
      color-link current-line-number "#D8DEE9,#4C566A"
      color-link color-column "#4C566A"
      color-link ignore "#D8DEE9, #4C566A"
      color-link divider "#4C566A"
    '';
    ## nord-16 (with transparency)
    "micro/colorschemes/nord-16.micro".text = ''
      color-link default "brightwhite"
      color-link comment "brightblack"
      color-link comment.bright "bold brightblack"
      color-link identifier "white"
      color-link identifier.class "brightcyan"
      color-link identifier.macro "brightblack"
      color-link identifier.var "white"
      color-link constant "white"
      color-link constant.bool "brightgreen"
      color-link constant.bool.true "brightgreen"
      color-link constant.bool.false "brightred"
      color-link constant.number "magenta"
      color-link constant.specialChar "yellow"
      color-link constant.string "green"
      color-link constant.string.url "brightyellow"
      color-link statement "cyan"
      color-link symbol "brightblack"
      color-link symbol.brackets "brightblack"
      color-link symbol.operator "brightblue"
      color-link symbol.tag "brightblue"
      color-link preproc "blue"
      color-link preproc.shebang "brightblack"
      color-link type "brightcyan"
      color-link type.keyword "brightblue"
      color-link special "brightblue"
      color-link underlined "brightwhite,black"
      color-link error "bold red"
      color-link todo "bold magenta"
      color-link statusline "blue,black"
      color-link tabbar "white,black"
      color-link indent-char "white"
      color-link line-number "brightblack,black"
      color-link gutter-error "red"
      color-link gutter-warning "yellow"
      color-link cursor-line "black"
      color-link current-line-number "white"
      color-link color-column "brightblack"
      color-link ignore "white, brightblack"
      color-link divider "brightblack"
    '';
  };
}
