{config, pkgs, ... }:
{
    # [import declared configs]
    imports =
        [(import ./pkgs.nix)]
        ++ [(import ./theming.nix)]
        ++ [(import ./env.nix)]
        #++ [(import ./nvidia.nix)]
        ++ (import ./configs)
    ;
    # ---

    # ================ #
    # define dotfiles:
    # ================ #
    xdg.configFile = {
    #    hypr.source = "${dotfiles}/hyprland/.config/hypr";;
        
    };
    # --> hyprland
        # [hyprland config]
        #xdg.configFile."hypr/hyprland.conf".source = ./configs/imported/hypr/hyprland.conf;
}
