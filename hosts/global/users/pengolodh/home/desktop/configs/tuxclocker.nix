{
  config,
  lib,
  ...
}: {
  programs.tuxclocker = {
    enable = true;
    enableAMD = true;
    useUnfree = false; 
  };
}
