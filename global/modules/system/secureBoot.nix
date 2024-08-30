{
  pkgs,
  lib,
  isImpermanent,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      sbctl
    ];
    persistence."/persist".directories = lib.mkIf isImpermanent [
      "/etc/secureboot"
    ];
  };

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
