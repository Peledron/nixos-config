{
  config,
  lib,
  ...
}: {
  home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

  # [starship]
  # dot from https://github.com/ChrisTitusTech/mybash/blob/main/starship.toml
  programs.starship = {
    enable = lib.mkDefault false;
    enableBashIntegration = true;
    enableFishIntegration = true; # if you have fish enabled
    #enableZshIntegration = true; # if you have zsh enabled
    settings = {
      format = lib.concatStrings [
        "[](#3B4252)"
        "$username"
        "[](bg:#434C5E fg:#3B4252)"
        "$directory"
        "[](fg:#434C5E bg:#4C566A)"
        "$git_branch"
        "$git_status"
        "[](fg:#4C566A bg:#86BBD8)"
        "$c"
        "$elixir"
        "$elm"
        "$golang"
        "$haskell"
        "$java"
        "$julia"
        "$nodejs"
        "$nim"
        "$rust"
        "[](fg:#86BBD8 bg:#06969A)"
        "$docker_context"
        "[](fg:#06969A bg:#33658A)"
        "$time"
        "[ ](fg:#33658A)"
      ];
      command_timeout = 5000;
      # Disable the blank line at the start of the prompt
      add_newline = false;

      # You can also replace your username with a neat symbol like  to save some space
      username = {
        show_always = true;
        style_user = "bg:#3B4252";
        style_root = "bg:#3B4252";
        format = "[$user ]($style)";
      };
      directory = {
        style = "bg:#434C5E";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };
      # Here is how you can shorten some long paths by text replacement
      # similar to mapped_locations in Oh My Posh:
      directory.substitutions = {
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        # Keep in mind that the order matters. For example:
        # "Important Documents" = "  "
        # will not be replaced, because "Documents" was already substituted before.
        # So either put "Important Documents" before "Documents" or use the substituted version:
        # "Important  " = "  "
      };
      c = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      docker_context = {
        symbol = " ";
        style = "bg:#06969A";
        format = "[ $symbol $context ]($style) $path";
      };
      elixir = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      elm = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      git_branch = {
        symbol = "";
        style = "bg:#4C566A";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:#4C566A";
        format = "[$all_status$ahead_behind ]($style)";
      };
      golang = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      haskell = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      java = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      julia = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      nodejs = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      nim = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
        format = "[ $time ]($style)";
      };
      nix_shell = {
        disabled = false;
        symbol = "󱄅";
        style = "bg:#86BBD8";
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        unknown_msg = "[unknown shell](bold yellow)";
        format = "[ $symbol ($state) ($name) ]($style)";
      };
    };
  };
}
