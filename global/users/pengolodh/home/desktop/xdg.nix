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
        # [default browser]
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/chrome" = ["firefox.desktop"];
        "application/x-extension-htm" = ["firefox.desktop"];
        "application/x-extension-html" = ["firefox.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop"];
        "application/xhtml+xml" = ["firefox.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop"];
        "application/x-extension-xht" = ["firefox.desktop"];
      };
      addedAssociations = {
        "text/plain" = ["codium.desktop"];
        "application/pdf" = ["zathura.desktop"];
        # [default browser]
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/chrome" = ["firefox.desktop"];
        "application/x-extension-htm" = ["firefox.desktop"];
        "application/x-extension-html" = ["firefox.desktop"];
        "application/x-extension-shtml" = ["firefox.desktop"];
        "application/xhtml+xml" = ["firefox.desktop"];
        "application/x-extension-xhtml" = ["firefox.desktop"];
        "application/x-extension-xht" = ["firefox.desktop"];
      };
      removedAssociations = {
        "inode/directory" = "codium.desktop";
      };
    };
  };
}
