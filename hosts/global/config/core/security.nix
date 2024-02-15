{
  config,
  lib,
  pkgs,
  ...
}: {
  security = lib.mkDefault {
    sudo.enable = false; # disable sudo by default
    doas = {
      enable = true;
      extraPackages = pkgs.doas-sudo-shim;
      wheelNeedsPassword = true;
      extraRules = [
        # creates a rule for group wheel that allows its users to persist passwords after prompting a single time (per session)
        {
          groups = [wheel];
          keepEnv = true; # Optional, retains environment variables while running commands
          persist = true; # Optional, only require password verification a single time
        }
      ];
    };
  };
}
