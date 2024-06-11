{
  config,
  pkgs,
  lib,
  ...
}: {
  services.pcscd = {
    enable = true;
    plugins = with pkgs.unstable; [
      acsccid
      ccid
      libacr38u
      scmccid
    ];
  };
}
