{
  config,
  pkgs,
  ...
}: {
  # enable the globally configured configs
  # see ../../configs/* for the configs
  programs= { 
    micro.enable = true;
    fish.enable = true;
    starship.enable = true; 
    direnv.enable = true;
  };
}