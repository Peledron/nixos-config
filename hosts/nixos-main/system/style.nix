{
  config,
  lib,
  pkgs,
  ...
}: {
  stylix = {
    enable = true;
    autoEnable = false; # i will disable that since I want to manage most theming with homeManager
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    targets = {
      # enable boot theming
      grub.enable = true;
      plymouth.enable = true; # the logo is nix by default and animated
      # pre-graphical tty
      console.enable = true; # theming for the linux kernel console
      kmscon.enable = true; # kmscon is the standard TTY of linux

      # nixos-logo theming
      nixos-icons.enable = true; # no idea what this does
    };
  };
}
