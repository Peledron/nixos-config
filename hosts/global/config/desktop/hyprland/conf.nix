{config, pkgs, dotfiles, ... }:
{
    # [import declared configs]
    imports = (import ./configs);
    # ---

    # [special env]
    home.sessionVariables = {
        # XDG
        # --> defined in hyprland config
#         XDG_CURRENT_DESKTOP = "Hyprland";
#         XDG_SESSION_TYPE = "wayland";
#         XDG_SESSION_DESKTOP = "Hyprland";
#
#         QT_QPA_PLATFORM = "wayland";
#         EGL_PLATFORM = "wayland";
#         CLUTTER_BACKEND="wayland";  # disable when not using wayland
#         GDK_BACKEND = "wayland";
#
#         # disable qt window borders
#         QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # set hyprconfigs variable so we can use that in configs (for scripts and such)
        #HYPRCONF = "$HOME/$FLAKEDIR/hosts/global/config/desktop/hyprland/configs";
    };
    # ---

    # ================ #
    # define dotfiles:
    # ================ #
    # --> import existing dotfiles from gitlab
    #xdg.configFile = {
    #    hypr.source = "${dotfiles}/hyprland/.config/hypr";
    #    waybar.source = "${dotfiles}/hyprland/.config/waybar";
    #    fuzzel.source = "${dotfiles}/hyprland/.config/fuzzel";
    #    dunst.source = "${dotfiles}/hyprland/.config/dunst";
    #    wob.source = "${dotfiles}/hyprland/.config/wob";
    #    wlogout.source = "${dotfiles}/hyprland/.config/wlogout";
    #    swaylock.source = "${dotfiles}/hyprland/.config/swaylock";
    #};
    # --> hyprland
        # [hyprland config]
        #xdg.configFile."hypr/hyprland.conf".source = ./configs/imported/hypr/hyprland.conf;

    # --> bar
        # [waybar config]
        #xdg.configFile."waybar/config".source = ./configs/waybar/config.jsonc;
        #xdg.configFile."waybar/style.css".source = ./configs/waybar/style.css;

    # --> notifications
        # [dunst config]
        # --> taken from christitus config (see ./configs/dunst/dunstrc)
        #xdg.configFile."dunst/dunstrc".source = ./configs/dunst/dunstrc; # replaced with declarativ config

    # --> terminal
        # [kitty config]
        #xdg.configFile."kitty/kitty.conf".source = ./configs/kitty/kitty.conf; # replaced with declarativ config

    # --> search
        # [rofi config]
        #xdg.configFile."rofi".source = ./configs/imported/rofi/rofi.rasi;

    # --> pipewire
        # [input-denoising]
        #xdg.configFile."pipewire/pipewire.conf.d/99-input-denoising.conf".source = ./configs/imported/pipewire/pipewire.conf.d/99-input-denoising.conf;
}
