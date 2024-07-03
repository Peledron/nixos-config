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
                      value = "eJx1WMmS4zgO_ZrxRVGO6SViYg6-zER3_0DfFRAJSyiRhIqLbeXXN6jFIlNZh1QmH0kQxPIApoKIPXvCcOvRoQdzMeD6BD3enPn2vz8uhhUYvKG7QIqs2E4GI9565t7ghaysbCfPr_n2t094sRgH1re__vj7EuCOAcGr4fbvSxzQ4i1Q3n7xGJKJoWXXOny2Ebp1s2ZqZY7NA_2NQYZX9v1l3dWGOIsiGvx4Uegi-hYM9c7K3-t20A9wCnW7nfonmICXHwn93JJrI0XZv6wkdydHUWQqz8as4LorK6VWq8wiyKDapA8cR5zDTeMdRPuLpgCdkdPQ9eTEgP_toW_bwIrANBY1wb9-_T84B6HJgumBbXsngyHD09hY8p59icktG_k2IbIvFztQ7DS0LcU8DGPbbt6SYUeG8k_bPkgjhwWKXVIjxm1HN3XVjqip7w_5i65XpdRVYyFFTZPHO3oUm26CxFohCCjXVJTxFXvqB4kfiyNmnD4NmyVUgghafm-guF-g_M2SkjeElaYwuIHvJaQRP8T1rU2B1DIOESKJFJYY8xnRfSNOyg4mdqHcjKIr6WPpk0bSEKE6QCyXf3r-Gj1fpJhbjVcYsZir7lrgT4SszqHVGggWJlku36y35e80ZTcdq355FSrcted8sd2lcnsdB4hWsq5c5hGbwPf4BI-NJi_RneN89e7dkxsJVLlhngtz9ZJB0O2xwBo79P02lDmUIGK7j5m1R9CFY1bOaCYDcw7zcKhbzliWYCpNaCUbfc4pUos738r1E2tdxsIAnYf82XQYQJLAr3ZfAXy9I1mkhivxNiaru0NTsn3yxUnkoFCInPxJnMLX2K7NdwoDHzIlSz34uckxFai4fJ7A6MEFIzqVQWe4CxGvfldfyBXUBG4f8sdA5Xr7tJ0pATft7nAzwHEk6zlgmes8oRBpxELfDHmcuNB0EntCT2HnFeGHjTSLM9_gOVGOqT1PvtpW5cmUOmGlx3agR60pnkjWc4xSBVgihbEIuFWgnQPVdhXqVimE6zRLsdqtqUDrOQewTcIce05M9G1ggyd8FZ1zoMmfN2rBRVJNULILfMmTQlM-TrlcFppEHmeOLIEyZrfuho7ZYCIDUrW4QDfzxCpsn9TN5QYp3C9w2lNFcJn0OuYxfAZ_JK7tlMHAyaszOqFasvQn8HHtDEs5D4vp6tUPnj-Z48nm7sGCmYZK5V9---0_r8M8Oml0pZs_HNgqEfg74nhGziG54VXMLQw0keF4nOHgkZnmEOhTN_do99ScEH1MXZlTS3TK9jEXxyd2xdQMqrJGHp9180nSuZRoxJJBkrDEnvyikZ0kSRNmx27OhH9YBkdfX26FTmet8Kl8he_TdXqWthaiUrHUPTz6TBOFrIeUIkMu7VybfW2lHFc3Ttaa-ZAr3PiouY-6g_jWIBxSPIpLxR1jf-1554kLuroxW1hlUajJquxtlJdELbQG_6JHGbmdpI4COx2MnndvVbjsv1z_eXy274JWjliQk8Ez6-Z0Kau2GvA-cmbZ3VrSKeW2bK4bowcJ-ci1ytaEcwVshrRX7SgWmStDY5wtOzFPETd3Q2osC6Asp7K29Zlu99oppf84YC3l5QFbcT-ZZMMro2zYySwb_gWtDtt5y-GjqA2hrK1o7dzs5L1SU1071hUpoP_ZnJTA-LO5LFlMcZ7--LbV-7rO5waA77LNSdKE0hrigP5RBZYFeQdodj9R7j09QBikNHyxQr87BXopw0kfDpQ6NRLujVKOOpBuMPfCAWNF4PucVGKJCth66npeWAExSq-6N6yTzlR4LJrk9ZQr7TZL-fmGoYzUKWdW4fFlfF3UPbSeKLdtHRRWlR5QiSWk38293R7AoqzN4goN5mnP_B9PyZPS0gtQB-IKnWJ2hU_h6UF6v6aT10Uo-9EgVQT2DungVE5CLLU7pDlQI0vi3w0_j3de6pKLaW9Rs9GctIDrY_KrFiNN6FN4u1Ve0qSlwfdriO4mSy5Ipx2G8i0GQ02pC1CbZOb0qcK9kfdjDMgIm-QYKZY9yObG8ihZQqOVZAHyliVbyqdZzi6JtuvJDeXkyRnlJCSdW_ySwPepxRpFT0EqfrCrmMtKMbXyPmre3bmuuxWvHY2HzkKJMb-8sgM-5eITjBmkxLnyFjH6K7lPRfB82xU-3XOF65oSf9_f9cf_JyaTpA6GWw7E13UbXQdhNemasJXMNrCGz5cLwmmGoV3_U_P00lifpgOae0vuzqcZCcVWipka3yX6a90UGJXE3OzPWuW4XQdn8X5577XJG1HO5nQ6rclloBX6lTnJpov038Jet38A8Vcv0A==";
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
