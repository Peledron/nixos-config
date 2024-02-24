{ config, ... }:
{
    programs.helix = {
        enable = lib.mkDefault false;
        settings = {
            theme = "base16_transparent";
        };
    };
}
