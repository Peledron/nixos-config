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
                  template = "https://searx.rhscz.eu";
                  params = [
                    {
                      name = "preferences";
                      # very long string ahead, contains all settings that are configued
                      value = "eJx1WMmS5LgN_RrnRdEZM25HOHzI04THP9B3BUQiJbRIQs0lM1Vfb1BLiixVH0pVfOACYnkAS0HEnj1huPXo0IO5GHB9gh5vYGTACgze0F0gRVZsJ4MRbz1zb_BCVua1k-fXfPvhE14sxoH17X___XEJcMeA4NVw--MSB7R4C5SXXzyGZGJo2bUOn22E7vY3mIAXzdSKkM0D_Y1Bhlf2_WVd1oY4iyZZjYtCF9G3YKh3Vv7e1oN-gFOo2-3cFf2V0M8tuTZSlA0WPcndyVGUTZVnY1ZwXZXVUqtVZtnIoIqreOA44hxuGu8g-l80BeiMnIauJycG_E8PfdsGVgSmsagJ_vHPv8A5CE3emB7YtncyGDI8jY0l79mXmFyzkW8TIvtysgPFTkPbUszDMLbt5i0ZdmQo_7TtgzRyWKDYJTVi3FZ0U1etiJr6_th_0fWqlLpqLHZR0-Txjh7FpttGYq0QBJRrKsr4ij31g8STxREzTp-GzRIsQTZafm-gBIBA-Zt3St4QVprC4Aa-l5BG_BDftzYFUss4RIgku7BEmc-I7htxUnYwsQvlYhRdSR9TnzSShgjVAWK5_NPz1-j5IoVsNV5hxEJW3bXAnwhZnUOrNRAsTDJdvllvyz9pym46Zv35KlS4a8_5YrtL5fY6DhCt5F05zSM2ge_xCR4bTV6iO8f56t27JzcSqHLBPBfm6iWDoNtjgTV26PttKDKUIGK7j5m1R9CFY1bWaCYDcw7zcKhbSixLMJUmtJKNPucUqcWdb-X6ibUuY2GAzkP-bDoMIEngV7uvAL7ekSy7hivxNiaru0NTsn3yxUnkoFCInPxJnMLX2K7NTwoDH3tKlnrwc5NjKlBx-SzA6MEFIzqVQWe4CxGvfldf6BXUBG4f8sdA5Xz7tJ0pATft7nAzwHEk6zlgmes8oTBpxELfDHmcuNB0EntCT2HnFeGHjTSLM9_gOVEO0Z4nXy2r8mRKnbDSYzvQo9YUTyTrOUYpAyyRwlgE3LqhnQPVdhXqVimE6zRLudqtqUDrOQewTcIce05M9G1ggyd83TrnQJM_b9SCi6SaoGQV-JInhaZ8nHLBLDSJPM4cWQJlzG7dDR2zwWQPSNXkAt3ME6uwfVI3lwukdL_AaU8VwWXS65jH8Bn8lbi2UwYDJ6_O6IRqydLfwMe1Myz1PCymq2c_eP5kjiebuwcLZhoqlf_8_v3fr8M8Oml0pZs_HNgqEfgn4nhGziG54VXMLQw0keF4nOHgkZnm2NCnbu7R7qk5IfqYujKnluiU5WMujk_sCtEMqrJGHp9180nSudzRiCWDJGGJPflFIztJkibMjt2cCf-wDI6-vtwKnc5a4VP5Cj-n6_QsbS1EpWKpe3j0mSaKvR5Sigy5tHNt9rWVclzdOFlr5mNf4cZHzX3UHcS3BuGQ4lFcKu4Y-2vPO09c0NWN2cIqi0JNVmVvo7wkaqE1-Bc9ysjtJHUU2Olg9Lx6q8Jl_-X6z-OzfRe0csSCnAyeWTenS1m11YD3kTPL7taSTim3ZXPdGD1IyEeuVbYmnCtgM6S9akexyFwZGuNs2Yl5iri5G1JjWQBlOpW1rc90u9dOKf3HAWspLw_YivvJJBteGWXDTmbZ8C9oddjOWw4fRW0IZW1Fa-dmJ--Vmurasc5IAf3vZFIC4-9keWcxxVn88W2r93Wdzw0A32WZk6QJpTXEAf2jCiwL8g7Q7H6j3Fs8QBikNHwxQ787BXopw0kfDpQ6NRLujVKOOpBuMPfCAWNF4LtMKrFEBWw9dS0XVkCM0qvuDeukMxUekyZ5PeVKu0kpv98wlJE65cwqPL6Mr4u6h9YT5batg8Kq0gMqsYT0u7m32wNYlLV5u0KDedoz_9dT8qS09ALUgbhCp5hd4VN4epDer-nkdRHKfjRIFYG9Qzo4lZMQS-0OaQ7UyJL4d8PP452XuuRi2lvUbDQnLeD6mPyqxUgT-hTebpWnNGlp8P0aorvJkgvSaYehfIvBUFPqAtQmmTl9qnBv5P0YAzLCJjlGimkPsrmxPEqW0Gi1swB5yZIt5dMsZ5dE2_XkhlJ4ckYphKRzi18S-C5arFH0FKTiB7uKuawUUyvvo-bdneu6W_Ha0XjoLJQY88srO-BTLj7BmEFKnCtvEaO_kvtUBM-3XeHTPVe4rinxX_u7_vj_xGSS1MFwy4H4um6jqwKjklyJ90b5EA1CeNJQYStJb2CNrC8nhJOEoV3_i_P00nOfxAHNvSV355NE9GilzqnxJMnE3QphSnJI_L-L-9e3yly4ic5H-OU52CZvREGbs-0i_bew1-3_XQcwKA==&q=%s";
                    }
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "safesearch";
                      value = "0";
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
