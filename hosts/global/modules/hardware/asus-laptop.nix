{
  config,
  pkgs,
  lib,
  ...
}: {
  # asus services
  # -> from https://asus-linux.org/wiki/nixos/
  services = {
    supergfxd = {
      enable = true;
      path = [pkgs.pciutils];
    };
    asusd = {
      enable = true;
      enableUserService = true;
      asusdConfig = ''
        bat_charge_limit: 90,
        panel_od: true,
        mini_led_mode: false,
        disable_nvidia_powerd_on_battery: true,
        ac_command: "${pkgs.asusctl}/bin/asusctl profile -P Balanced",
        bat_command: "${pkgs.asusctl}/bin/asusctl profile -P Quiet",
      '';
    };
  };
}
