{
  config,
  pkgs,
  lib,
  ...
}: {
  # hardware settings
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
    };
  };
}
