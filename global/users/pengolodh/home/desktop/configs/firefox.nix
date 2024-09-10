{
  pkgs,
  mainUser,
  ...
}: {
  stylix.targets.firefox.profileNames = [mainUser];
  # a lot of these options come from: https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
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
          # https://mozilla.github.io/policy-templates/#extensionsettings
          # "force_installed" and "normal_installed" both auto-install the addon, the differnce is that force = the user cannot disable the addon
          # the url follows the pattern: https://addons.mozilla.org/firefox/downloads/latest/<addon name>/latest.xpi
          # -> addon name is with'-'instead of'_' you can find it in the link of "add to firefox" in the addon store https://addons.mozilla.org/en-US/firefox
          #---
          "*".installation_mode = "allowed"; # Valid strings for installation_mode are "allowed", "blocked", blocked blocks all addons except the ones specified below
          # [adds and tracker removers]
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # localcdn:
          "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # Firefox Multi-Account Containers:
          "@testpilot-containers" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            installation_mode = "normal_installed";
            default_area = "navbar";
          };
          # facebook container:
          "@contain-facebook" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/facebook-container/latest.xpi";
            installation_mode = "force_installed";
          };

          # [annoyance remover]
          # I still don't care about cookies:
          "idcac-pub@guus.ninja" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
            installation_mode = "force_installed";
          };
          # Auto Mute Plus:
          "autoMutePlus@rogerskeie" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-mute-plus/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # Unpaywall:
          "{f209234a-76f0-4735-9920-eb62507a54cd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/unpaywall/latest.xpi";
            installation_mode = "force_installed";
          };
          # bypass paywalls clean
          /*
            "magnolia@12.34" = {
            install_url = "https://github.com/bpc-clone/bpc_updates/releases/download/latest/bypass_paywalls_clean-latest.xpi";
            installation_mode = "force_installed";
          }; # got taken down by DMCA claim
          */

          # [youtube related]
          # sponsorblock:
          "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # dearrow:
          "deArrow@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/dearrow/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # return youtube dislike:
          "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
            installation_mode = "force_installed";
          };
          # blocktube:
          "{58204f8b-01c2-4bbc-98f8-9a90458fd9ef}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/blocktube/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };

          # [functionality]
          # bitwarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "normal_installed"; # it seems to log itself out if there is an update otherwise
          };
          # darkreader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # go to playing tab:
          "{c52f9e9f-dbe3-4ee4-9515-4cec6a51b551}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/go-to-playing-tab/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # Image Search Options:
          "{4a313247-8330-4a81-948e-b79936516f78}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/image-search-options/latest.xpi";
            installation_mode = "force_installed";
          };
          # TWP - Translate Web Pages:
          "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/traduzir-paginas-web/latest.xpi";
            installation_mode = "force_installed";
          };
          # WebToEpub:
          "WebToEpub@Baka-tsuki.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/webtoepub-for-baka-tsuki/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
          };
          # Reddit Enhancement Suite
          "jid1-xUfzOsOFlzSOXg@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/reddit-enhancement-suite/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
    };

    # profiles:
    # --> needed for extention settings to work
    profiles = {
      # see https://mipmip.github.io/home-manager-option-search/ firefox for more options
      ${mainUser} = {
        id = 0;
        name = mainUser;
        isDefault = true;
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
                    /*
                    {
                      name = "preferences";
                      # very long string ahead, contains all settings that are configued
                      value = "eJx1WMuS47oN_Zp4oxrXvZlUpbLw6lZufmD2KoiEJYxIQsOHbfXXB9TDIls9i1Y3AT7AA-AAbAURe_aE4dajQw_mYsD1CXq8QYp8MazA4A3dJQ8V28lgxFvP3Bu8kJWJ7eT5Nd9--IQXi3Fgffvff39cAtwxIHg13P64xAEt3gLl5RePIZkYWnatw2cboVsXa6ZWdGwe6G8MMryy7y_rqjbEWQzR4MeLQhfRt2Cod1b-XpeDfoBTqNvt1L_BBLz8SujnllwbKcr6ZSa5OzmKsqfybMwqXFdlo9QKyiwbGVTb7gPHEedw03gHsf6iKUBn5DR0PTnB7z899G0bWBGYxqIm-Mc__wIzibIx5NKrmUCNgldoW4pZ5xyEJh9KD2zbOxkMWTyNjSXv2ZcyQaCRbxMi-3KyA8VOw75lGNt2c6QMOzKUf9r2QRo5LKLYJTVi3FZ0U1etiJr6_th_ucdVKXXVWOyipsnjHT0K3ttGgmQIIhQIFGX5KnvqB4mPiyNmnD4NmyWMMizL700ooSGi_M07JW8IK0thcAPfS5FG_JCwaG0KpJZxiBBJdmGJP58lum_Egdn5xC6Ui1FsJX1MfdJIGiJUBwhy-afns8mFboWpgKvQVbcq5E-EfPBx_upyC5NMl2-20PJPmrJDjll_vgoT7tpzvsLuPLmnjgNEK7lXTvOITeB7fILHRpOXGM_Rvvrx7smNBKpcMM8FML3kEXS711ljh77fhqJDCRe2-5hZewRduGBljmYyMOeADoe5pcayhE0JoZWc9DmzSC2OexvXT6x16fUBOg_5s9kwSNahX3FfBfh6x6zsGq7E25is7g5LyfbJFyeRg8IgcvIncQpfy3ZrflIY-NhT8tGDn5scU4GKy2cFRg8uGLGpDDrDXYh49bv5QrGgJnD7kD8GKufbp-1MKXDT7g43AxxHsp4DllnNEwqdRizszSKPExeWrixGYWcQYYKNOosz38JzohyqPU--WlblyZQ64Z_HdqBHrSmeqNZzjFILWCKFsQi4dUM7B6pxFQJXKYTrNEvJ2tFUoPWcA9gm4Yg9Jyb6NrDBk3zdOudAkz9vqQUXSTVBySrwJSMKIfk45aJZWBJ5nDmyBMqY3boDHTNgsgekanIh3eCJVdg-qZvLBVK-X-C0p4rKMr11zGP4LPyVuMYpCwMnr87SCdWSpb8RH9fOYinqYYGunv3g-RMcTzZ3D1ZK51CZ_Of37_9-HfDopNGVbv5wYKtE4J-I4zkAN3kVYQvfTGQ4Hjs6eGReOTb0qZt7tHsiTog-pq7MoCUWZfmYi94Tu0I1g6runsdn23yS5C13NIJbkJQrZU9-0chOUqIJs2M3Z3o_cMDR15dbRaezVvGpWIWf03V6lsgKLalY2h4efSaFYq-HFJ6lydmwyZ61UmarGydrzXzsK0z4qJmOuoPm1pAbUjxKScUUY3_teWeFC7q6GVs4ZO26sil7e-QlLQurwb_oUcZpJ4miwE4Hf-fVW80t-yrXfx6f8V2klSMWyQnwzLE5OcoarQa8j5w5dUdLOqDcbs11w_MgoRq5VtmIcK53zZD2Gn10GRWPCE5zBT_G2bIT0IpouhtSY1kEZTqV9a3PlLvXTyn_x7FrOS8P2Ar8CahNXkG1yU5gbfIvqHXYzlsOH8VsCGV9RWvnZifwlZ7q-rHOSAH973RSBuPvdHlngeKs_vi21fy61ucmgO-yzEkqhRINcUD_qMLNgnT9mt1vjHurBwiDlIcvZuh3t0AvZTjpw4FSq0bCvVnKsQjSEebON2CsSHzXSTWWqICtg671whWIUfrVvWmddCbIY9Ik76hcbTct5YcchjJ-p5xvhceX8XUx97B6oty6dVCgKn2gEiSk58393R7AYqzN2xUWzNPOB7-ekj0l0ougDsRVdIrZVXwKTw_S_zWdvCVC2ZMGqS2wd0kH03ISuqndIQ2CGlno4G74ebzqUpdcTHubmkFz0gauT8ev2ow0oU_h7VZ5U5OWJt-vIbpDllyQbjsM5csLhppoF0ENyczpU917S95PLyAjbJJjpJj2IJuby6OQCblWO4sgL1mypXyI5eySaLue3FAqT84olZB0bvNLWt9VCxpFX0EqfrCrmMtKibXyRmreHbo-dxp1D-O1o_G4hZBkzO-x7JJP2fkEYwYpha68V4z-Su5TsTzffxWfbr6K69oT_7W_64__XUwmSb0Mtxyar-s2ug7Cc9JLYSu5bmANqC8nhJOGoV3_i_P00m6f1AHNvSV355NGgrOVoqfGdyn_2jYFRiVxAPuzVTmS18F5e7-8AtvkjRhnc4Kd5uTC0Aohi07y6yJdufDZ7f8e-zpu";
                    }
                    */
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
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master";
                    }
                  ];
                }
              ];
              iconUpdateURL = "https://avatars.githubusercontent.com/u/33221035?s=48&v=4";
              updateInterval = 24 * 60 * 60 * 1000; # every 24 hrs (in ms)
              definedAliases = ["@ho"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";}];
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
          "media.av1.enabled" = true; # set to true if your gpu supports av1 decoding
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;

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
