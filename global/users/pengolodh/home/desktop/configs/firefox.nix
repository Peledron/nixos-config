{
  config,
  pkgs,
  lib,
  ...
}: {
  stylix.targets.firefox.profileNames = ["pengolodh"];
  # a lot of these options come from: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  programs.firefox = {
    enable = true;
    package = pkgs.unstable.wrapFirefox pkgs.unstable.firefox-unwrapped {
      extraPolicies = {
        # Check about:policies#documentation for options.
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisableFirefoxScreenshots = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
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
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on" (enables server-side menubar, instead of the build in one, good for tiling wm's)

        # we can install extentions for all profiles here:
        ExtensionSettings = {
          # Check about:support for extension/add-on ID strings.
          # Valid strings for installation_mode are "allowed", "blocked", blocked blocks all addons except the ones specified below
          # "force_installed" and "normal_installed".
          # the url follows the pattern: https://addons.mozilla.org/firefox/downloads/latest/<addon name>/latest.xpi
          # -> addon name is with'-'instead of'_' you can find it in the link of "add to firefox" in the addon store https://addons.mozilla.org/en-US/firefox
          #---
          "*".installation_mode = "allowed";
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # localcdn:
          "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
            installation_mode = "force_installed";
          };
          # sponsorblock:
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
          };
          # dearrow:
          "deArrow@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
            installation_mode = "force_installed";
          };
          # return youtube dislike:
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/return_youtube_dislikes/latest.xpi";
            installation_mode = "force_installed";
          };

          # bitwarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "normal_installed"; # it seems to log itself out if there is an update otherwise
          };
          # darkreader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
          # go to playing tab:
          "{c52f9e9f-dbe3-4ee4-9515-4cec6a51b551}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/go_to_playing_tab/latest.xpi";
            installation_mode = "force_installed";
          };
          # blocktube:
          #"{58204f8b-01c2-4bbc-98f8-9a90458fd9ef}" {

          #};
        };
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
        # --> only usefull if you dont use an existing firefox profile..., also these will be disabled by default so... IDK how to actually enable them
        # find more at https://nur.nix-community.org/repos/rycee/
        #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # [privacy]
        #multi-account-containers # --> seems to break the syncronized containers if this is enabled
        # privacy-badger
        # localcdn
        # # [ad-blocking]
        # ublock-origin
        # sponsorblock
        # # [passwords]
        # bitwarden
        # # [QoL]
        # darkreader
        # #bypass-paywalls-clean
        # #fastforward
        # #firefox-translations # translate webpages does not exist, uses offline translator so this is prob a better choice anyway
        # return-youtube-dislikes
        # reddit-enhancement-suite
        #];
        # ---
        search = {
          force = true;
          default = "searx";
          engines = {
            "searx" = {
              urls = [
                {
                  template = "https://searx.rhscz.eu/search";
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
                      name = "preferences";
                      # very long string ahead, contains all settings that are configued
                      value = "eJx1WMuS47oN_Zp4oxrXvZlUpbLw6lZufmD2KoiEJYxIQsOHbfXXB9TDIls9i1Y3D0kQxOMAbAURe_aE4dajQw_mYsD1CXq8QYp8MazA4A3dJQ8V28lgxFvP3Bu8kJWF7eT5Nd9--IQXi3Fgffvff39cAtwxIHg13P64xAEt3gLl7RePIZkYWnatw2cboVs3a6ZW5tg80N8YZHhl31_WXW2IsyiiwY8XhS6ib8FQ76z8vW4H_QCnULfbqX-DCXj5ldDPLbk2UpT9y0pyd3IURabybMwKrruyUmo1yiyCDKpN-sBxxDncNN5BtL9oCtAZOQ1dT07s958e-rYNrAhMY1ET_OOff4FzEJosmB7YtncyGDI8jY0l79mXmNyykW8TIvtysQPFTkPbUszDMLbt5iwZdmQo_7TtgzRyWKDYJTVi3HZ0U1ftiJr6_pC_6HpVSl01FlLUNHm8o0ex6SZIrBWCgHJNRRlfsad-kPixOGLG6dOwWUIliKDl9waK-wXK3ywpeUNYaQqDG_heQhrxQ1zf2hRILeMQIZJIYYkxnxHdN-Kk7GBiF8rNKLqSPpY-aSQNEaoDxHL5p-ev0fNFirnVeIURi7nqrgX-RMjqHFqtgWBhkuXyzXpb_klTdtOx6s9XocJde84X210qt9dxgGgl68plHrEJfI9P8Nho8hLdOc5X7949uZFAlRvmuTBXLxkE3R4LrLFD329DmUMJIrb7mFl7BF04ZuWMZjIw5zAPh7rljGUJptKEVrLR55witbjzrVw_sdZlLAzQecifTYcBJAn8avcVwNc7kkVquBJvY7K6OzQl2ydfnEQOCoXIyZ_EKXyN7dr8pDDwIVOy1IOfmxxTgYrL5wmMHlwwolMZdIa7EPHqd_WFXEFN4PYhfwxUrrdP25kScNPuDjcDHEeyngOWuc4TCpFGLPTNkMeJC00nsSf0FHZeEX7YSLM48w2eE-WY2vPkq21VnkypE1Z6bAd61JriiWQ9xyhVgCVSGIuAWwXaOVBtV6FulUK4TrMUq92aCrSecwDbJMyx58RE3wY2eMJX0TkHmvx5oxZcJNUEJbvAlzwpNOXjlMtloUnkcebIEihjdutu6JgNJjIgVYsLdDNPrML2Sd1cbpDC_QKnPVUEl0mvYx7DZ_BX4tpOGQycvDqjE6olS38DH9fOsJTzsJiuXv3g-ZM5nmzuHiyYaahU_vP793-_DvPopNGVbv5wYKtE4J-I4xk5h-SGVzG3MNBEhuNxhoNHZppDoE_d3KPdU3NC9DF1ZU4t0Snbx1wcn9gVUzOoyhp5fNbNJ0nnUqIRSwZJwhJ78otGdpIkTZgduzkT_mEZHH19uRU6nbXCp_IVfk7X6VnaWohKxVL38OgzTRSyHlKKDLm0c232tZVyXN04WWvmQ65w46PmPuoO4luDcEjxKC4Vd4z9teedJy7o6sZsYZVFoSarsrdRXhK10Br8ix5l5HaSOgrsdDB63r1V4bL_cv3n8dm-C1o5YkFOBs-sm9OlrNpqwPvImWV3a0mnlNuyuW6MHiTkI9cqWxPOFbAZ0l61o1hkrgyNcbbsxDxF3NwNqbEsgLKcytrWZ7rda6eU_uOAtZSXB2zF_WSSDa-MsmEns2z4F7Q6bOcth4-iNoSytqK1c7OT90pNde1YV6SA_ndzUgLj7-ayZDHFefrj21bv6zqfGwC-yzYnSRNKa4gD-kcVWBbkHaDZ_Ua59_QAYZDS8MUK_e4U6KUMJ304UOrUSLg3SjnqQLrB3AsHjBWB73NSiSUqYOup63lhBcQoveresE46U-GxaJLXU6602yzl5xuGMlKnnFmFx5fxdVH30Hqi3LZ1UFhVekAllpB-N_d2ewCLsjaLKzSYpz3zfz0lT0pLL0AdiCt0itkVPoWnB-n9mk5eF6HsR4NUEdg7pINTOQmx1O6Q5kCNLIl_N_w83nmpSy6mvUXNRnPSAq6Pya9ajDShT-HtVnlJk5YG368hupssuSCddhjKtxgMNaUuQG2SmdOnCvdG3o8xICNskmOkWPYgmxvLo2QJjVaSBchblmwpn2Y5uyTaric3lJMnZ5STkHRu8UsC36cWaxQ9Ban4wa5iLivF1Mr7qHl357ruVrx2NB46CyXG_PLKDviUi08wZpAS58pbxOiv5D4VwfNtV_h0zxWua0r81_6uP_4_MZkkdTDcciC-rtvoOgirSdeErWS2gTV8vlwQTjMM7fqfmqeXxvo0HdDcW3J3Ps1IKLZSzNT4LtFf66bAqCTmZn_WKsftOjiL98t7r03eiHI2p9NpTS4DrdCvzEk2XaT_Fva6_R8SYC_7";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://searx.github.io/searx/_static/searx_logo_small.png";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@s"];
            };
            "Nix Package search" = {
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
            "Nix Option search" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
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
              definedAliases = ["@no"];
            };
            "Home Options search" = {
              urls = [
                {
                  template = "https://mipmip.github.io/home-manager-option-search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://avatars.githubusercontent.com/u/33221035?s=48&v=4";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@ho"];
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
          # [privacy]
          "privacy.trackingprotection.enabled" = true; # I think this is the default
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.webrtc.legacyGlobalIndicator" = false; # Hide the "sharing indicator" window
          ## disable auto-fill of forms and searchbar
          "browser.formfill.enable" = false;
          "browser.search.suggest.enabled" = false;
          "browser.search.suggest.enabled.private" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;

          # [basic accel]
          "gfx.canvas.accelerated" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "layout.frame_rate" = 144;

          # [video accel]
          # --> for nvidia see https://github.com/pop-os/nvidia-vaapi-driver#firefox
          #"gfx.x11-egl.force-enabled" = true;
          "media.av1.enabled" = true; # set to true if your gpu supports av1 decoding
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          # "widget.dmabuf.force-enabled" = true; #  only enable on older nvidia cards (pre pascal or using 470 driver)

          # [others]
          "widget.use-xdg-desktop-portal" = true; # tells firefox to use xdg-desktop-portal
          "widget.use-xdg-desktop-portal.file-picker" = 1; # tells firefox to use the kde filepicker, doesnt seem to work...
          "widget.wayland.opaque-region.enabled" = false; # prevents screen flicker when going fullscreen under wayland
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
