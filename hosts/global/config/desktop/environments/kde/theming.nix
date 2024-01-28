{ config, lib, pkgs, ... }:
let
    qt-theme = "Utterly-Nord";
    qt-theme-package = "utterly-nord-plasma";
in
{
    qt = {
        enable = true;
        platformTheme = "kde";
        style.name = "kvantum";
    };
    xdg.configFile = {
        "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=${qt-theme}";
        "Kvantum/${qt-theme}".source = "${pkgs.${qt-theme-package}}/share/Kvantum/${qt-theme}";
            
    }; # from https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/2 and https://discourse.nixos.org/t/guide-to-installing-qt-theme/35523/3
}