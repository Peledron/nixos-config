{
  lib,
  pkgs,
  ...
}: {
  programs.konsole = {
    enable = true;
    defaultProfile = lib.mkIf config.programs.fish.enable "fish";
    profiles = {
      fish = {
        command = "${pkgs.fish}/bin/fish";
      };
    };
  };
}
