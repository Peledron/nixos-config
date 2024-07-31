{
  config,
  pkgs,
  ...
}: {
  programs.swaylock = {
    settings = {
      # [settings]
      daemonize = true;
      show-failed-attempts = true;
      ignore-empty-password = true;

      # [effects]
      effect-blur = "5x5";
      fade-in = "0.1";

      # [clock]
      clock = true;
      datestr = "%d.%m";

      # [indicator]
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;

      # [grace-period]
      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;

      # [font]
      font = "Inter";

      # [color]
      color = "1f1d2e80";
      separator-color = "00000000";

      # --> line
      line-color = "1f1d2e";
      line-ver-color = "eb6f92";
      line-wrong-color = "1f1d2e";
      line-clear-color = "1f1d2e";

      # --> ring
      ring-color = "191724";
      ring-ver-color = "eb6f92";
      ring-wrong-color = "31748f";
      ring-clear-color = "9ccfd8";

      # --> inside
      inside-color = "1f1d2e";
      inside-ver-color = "1f1d2e";
      inside-wrong-color = "1f1d2e";
      inside-clear-color = "1f1d2e";

      # --> text
      text-color = "e0def4";
      text-ver-color = "e0def4";
      text-wrong-color = "31748f";
      text-clear-color = "e0def4";
      text-caps-lock-color = "";

      # --> highlight
      key-hl-color = "eb6f92";
      bs-hl-color = "31748f";
    };
  };
}
