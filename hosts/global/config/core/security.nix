{
  config,
  lib,
  pkgs,
  ...
}: {
  security = lib.mkDefault {
    polkit.enable = true;
    sudo.enable = false; # disable sudo by default
    doas = {
      enable = true;
      wheelNeedsPassword = true;
      extraRules = [
        # creates a rule group wheel to persist passwords after prompting a single time (per session)
        {
          groups = ["wheel"];
          keepEnv = true; # Optional, retains environment variables while running commands
          persist = true; # Optional, only require password verification a single time
        }
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    doas-sudo-shim # shim that makes it to that sudo and some of its flags are mapped to doas
  ];
}
