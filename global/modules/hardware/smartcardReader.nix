{
  config,
  pkgs,
  lib,
  ...
}: {
  services.pcscd = {
    enable = true;
    plugins = with pkgs; [
      acsccid
      ccid
      libacr38u
      scmccid
    ];
  };
}