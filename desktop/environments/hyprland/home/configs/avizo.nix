{
  config,
  pkgs,
  ...
}: {
  services.avizo = {
    enable = true;
    package = pkgs.avizo;
    settings = {
      defaults = {
        time = 1.0;
        width = 186; # 248
        height = 174; # 232
        background = "rgba(40, 42, 51, 0.8)";
        border-color = "rgba(51, 238, 255, 0.8)";
        bar-fg-color = "rgba(51, 238, 255, 0.8)";
      };
    };
  };
}
