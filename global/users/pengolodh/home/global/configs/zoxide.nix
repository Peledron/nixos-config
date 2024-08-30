{lib, ...}: {
  programs.zoxide = {
    enable = lib.mkDefault false; # automatically enables the fish integration, other shells are also enabled by default
    options = [
      "--cmd cd" # add a command alias that replaces cd with zoxide
    ];
  };
}
