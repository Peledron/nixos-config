{config, pkgs, dotfiles, ... }:
{
    # [import declared configs]
    imports =
        [(import ./pkgs.nix)]
        #++ [(import ./nvidia.nix)]
        ++ (import ./configs)
    ;
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
}
