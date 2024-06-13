{
  config,
  lib,
  pkgs,
  ...
}: {
  home.xdg = {
    enable = true;
    # set the default applications for certain filetypes
    # see https://www.sitepoint.com/mime-types-complete-list/ for a full list of mimetypes
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = ["codium.desktop"];
        "application/pdf" = ["zathura.desktop"];
      };
    };
  };
}
