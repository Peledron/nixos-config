{config, pkgs, ... }:
{
    xdg.configFile."wob/wob.ini".text = ''
        ; WOB CONFIG
        ; ============================
        bar_color        = 33ccffff
        border_color     = 595959aa
        background_color = 282a33EE
        anchor           = center
        margin           = 450
        width            = 200
        height           = 40
        overflow_mode    = wrap
        output_mode      = focused
        timeout          = 1000
        max              = 100

        ; ALTERNATIVE - MANJARO STYLES
        ; ============================
        ;bar_color        = FFFFFFFF
        ;border_color     = 16a085FF
        ;background_color = 3B758CEE
    '';
}