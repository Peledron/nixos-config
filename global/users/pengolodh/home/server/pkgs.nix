{pkgs, ...}: {
  home.packages = with pkgs; [
  ];

  #==================#
  # set programs to be managed by home-manager:
  # --> program configs are within ./configs
}
