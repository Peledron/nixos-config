{
  config,
  pkgs,
  lib,
  ...
}: {
  #nixpkgs.config.packageOverrides = pkgs: { ... };
  # find more at https://nur.nix-community.org/repos/rycee/
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        ExtensionSettings = {};
      };
    };

    # profiles:
    # --> needed for extention settings to work
    profiles = {
      # see https://mipmip.github.io/home-manager-option-search/ firefox for more options
      pengolodh = {
        id = 0;
        name = "pengolodh";
        isDefault = true;

        # extentions :
        # --> only usefull if you dont use an existing firefox profile...
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          # [privacy]
          #multi-account-containers
          privacy-badger
          privacy-possum
          localcdn
          # [ad-blocking]
          ublock-origin
          sponsorblock
          # [passwords]
          bitwarden
          # [QoL]
          darkreader
          #bypass-paywalls-clean
          #fastforward
          firefox-translations # translate webpages does not exist, uses offline translator so this is prob a better choice anyway
          return-youtube-dislikes
          reddit-enhancement-suite
        ];
        # ---
        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "searx" = {
              urls = [
                {
                  template = "https://searx.tiekoetter.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "safesearch";
                      value = "0";
                    }
                    {
                      name = "theme";
                      value = "simple";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://searx.github.io/searx/_static/searx_logo_small.png";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@s"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@nw"];
            };
            "Arch Wiki" = {
              urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://www.archlinux.org/logos/archlinux-icon-crystal-64.svg";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@aw"];
            };
            "Wikipedia (en)".metaData.alias = "@wiki";
            "Google".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };
        settings = {
          # [general]
          "general.smoothScroll" = true;
          "browser.compactmode.show" = true;

          # [basic accel]
          "gfx.canvas.accelerated" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "layout.frame_rate" = 144;

          # [nvida accel]
          # --> see https://github.com/pop-os/nvidia-vaapi-driver#firefox
          #"gfx.x11-egl.force-enabled" = true;
          "media.av1.enabled" = true; # set to true if your gpu supports av1 decoding
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          # "widget.dmabuf.force-enabled" = true; #  only enable on older nvidia cards (pre pascal or using 470 driver)

          # [others]
          "widget.use-xdg-desktop-portal" = true; # tells firefox to use xdg-desktop-portal for filepicker I think
          "widget.wayland.opaque-region.enabled=false" = false; # prevents screen flicker when going fullscreen under wayland
        };
      };
    };
    # ---

    # about:config settings:
    /*
       --> does not work in home-manager
    preferences = {
        # nvidia vaapi-driver https://github.com/elFarto/nvidia-vaapi-driver specific
        "media.ffmpeg.vaapi.enabled" = true;
        "media.av1.enabled" = false; # set to true if your gpu suppors av1
        "gfx.x11-egl.force-enabled" = true;
    };
    */
    # ---
  };
}
