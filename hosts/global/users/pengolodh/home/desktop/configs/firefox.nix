{
  config,
  pkgs,
  lib,
  ...
}: {
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
          # bitwarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
          # darkreader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
          # go to playing tab:
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
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
        ];
        # ---
        search = {
          force = true;
          default = "searx";
          engines = {
            "searx" = {
              urls = [
                {
                  template = "https://searx.be/search";
                  params = [
                    {
                      name = "preferences";
                      # very long string ahead, contains all settings that are configued
                      value = "eJx1WMuO6zgO_ZrOxqhgeu4AjVlkNcBse4DpvUFLtM1rSdSV5CSur2_Kj1iOqxZlRKRMUXycQ5eChB0Hwnjr0GEAczHguhE6vIGRBSsweEN3gTGxYusNJrx1zJ3BC1nZV_vAz-n2VxjxYjH1rG__-_P_f10itBgRgupv_7ikHi3eOCoIl4BxNCnW7GqHjzpBc_svmIgXzVSLks0dw41BllcO3WV-6yOmSRwx3JFijfcPDWG4RMoO1Ytulih0CUMNhjpn5fdqGvQdnEJdrx4t0l8jhqkmVydKYmC-ArmWHCUxqgIbs-5cXssuqyVik1gyqDb7PacBp3jT2IJc7qIpQmPkPHQdOYnuvzvo6jqyIjCVRU3w2z__A85BrLJlumNdt2QwZrEfKkshcChlctFKnlVMHMrNDhQ7DXVNKS9DIiW_c2ZmdXjSXQ5WhHJ_ETRkKP_V9Z00cpxFqRnVgGm10fimrtdyyMukqev2E5VSH-levM8enaQsYnGuBC_GgG15tMge-k6S88L6hP5tWS1GCmNZKKUiovzMlsZgCA9OQu96bkuRRvyUUqjtGEnN6zuBSxKhwrTWXSVJyykndrF8_0EDaUhwsClxyn8dV8v1izAUuoOzS-oseBHJUyRJSmI6uP_7s_Cp1YFJ7wFvDakhlBsCYhW5TQ8IWGkKUoi5JJf0tYHcQFBWQSf1Dc2qz_3TYOjW5dLLVVQ9GwhlvlaNNzDlyou7R6XGsqS0jIOVDgm5zKVTXZnGzrPWZUZ6aALkx-pKD1KFYQneLCDbjeXFyUFxEDn5STyWh0txBwhTlUMbqXD582NV7aJtL7eVeNoJ9JTeGm5iwmvYfIFPMwVScXdf0A6UB7dusA_bmDKpzttV5SaA_VzWU0R8a6CAngt3vYQCOopbT3rygib7Kz6s4Foe-BKeW2hXbXX71WuHuvVjc5We2RwYG5s92Mvj10O66dwGET3B5lshzYJcelV-vEoVLOQ0bIKIVoyS-qocY25dnxmn8D3xMHHi2POQE7GFT0iEtPREEAoooppyNMQ0jAcbhXS9--iiFHfsSxCCnvkAVTymsSnz-JK8IAfITJYztBTb7mSRi_WDmqk0LIz7BKelh97hqGEeThj1a-SE78LIY1BnqUc1N-s34j3YWZwxndL0vvvO01sSHmyWTPr-iJak0ie7I9L9-PHHs0gUfjqw5QbLPxGHQx_BPaPGLghjM3Vot870iOEtEzPDytAxZLp5YFMmCdThSnl97pcwSjPjoYBxCMcGWUSnVxfxuS9SAJXKk-O9y11fvJrDa4WLDswW4I4nwfVkX9poB6sl_f2YdpA_dPzQXTveuvuC7jiszFhgyI3PKnu0jQVSkwqs38s7K32O9ME9ct37-hykWXqI5iw53Ur12A6coYQlnWHhfunqYw41CjikDPfbLs2ZSqp-3FgPZfjIpPra8GLrb_j95HKhe2AurrBbQ6naLRQvWZLWdxJG3GXtNBU-yLk0FoQi65QTtaSM0u695E8HBF3ccOHg0vmVlU-Or_JDtFfZKd79anWlX93sBxZ0uzn8kwR49x2DzCkQC7w1aO0kgG_tmAesGWKOI_CyY4wYvtMJLabvdNnygvDvaimm-6EsLcjgrNl9c9ZL3QvqCyF8sUO_iJ6eyvCoi0kAZOLCbYzJdA4ylOXhMWI64OqmEzqVqQ7WofOoF6RATDIqbvOi1xnc9k1ePjcyo6xayp88GMuxdh4XrrN7u5eegoxmDRQjkExkSm5OTuNzz6Of_Nb0M8mXcVxY_1BLi-gMoSDVUjXSd7Ec-iQumtIpvIFTyuUv0yNjUeaCZAI7x3BLs6uBhRRaw49tPIvD2IwujVvt5qA4mdCWr6uv5onRYxjjK23pUO0z3R_vmeHuXZATOA-V23t5Uy5Lyev1FBI7WUEKGTmFC1w0ko0DIml0-3Keqz0ZToVxDtrRUAqeNLATJK_i5NiJ_SJ0P_3VPwqTAi6pzbkOp_A_5Gu_F15xJRulFK5UvD-N1prirgsTnbF9Fh_BPf1r-4Lcv429GYVv4i3Phs_ruroy1Ms_Ah5BPsPX0XFXy2d3K5_sLZ80Mu7VQhdqePHZ1wfkDl9VJxu9gI3MIyjHy_ynzsdnEhdiqeUDVPbYXIQXmUGlaW9_AyDUiGs=";
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
              urls = [{template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";}];
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
