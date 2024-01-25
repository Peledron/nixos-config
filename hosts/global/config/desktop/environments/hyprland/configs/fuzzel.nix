{config, pkgs, ... }:
{
    programs.fuzzel = {
        enable = true;
        settings = {
            # output="<not set>";
            font = "UbuntuMono Nerd Font:size=14";
            dpi-aware = true;

            
            icon-theme = "Papirus-Dark";
            icons-enabled = true;
            # prompt="> ";
            # fields="filename,name,generic";
            # password-character="*";

            fuzzy = true;

            # show-actions="no";
            # terminal="$TERMINAL -e"; # Note: you cannot actually use environment variables here
            # launch-prefix=<not set>;
            
            # lines=15;
            line-height = 18;
            # letter-spacing=0;

            width = 35;
            horizontal-pad = 10;
            vertical-pad = 10;
            inner-pad = 10;
            
            # image-size-ratio=0.5
            
            colors = {
                background = "282a33AA";
                text = "efefefef";
                match = "fabd2fff";
                selection-match = "fabd2fff";
                selection = "666666ff";
                selection-text = "efefefef";
                border = "33eeffee";
            };
            border = {
                width = 2;
                radius = 3;
            };
        };
    };
}