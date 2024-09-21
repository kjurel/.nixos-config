{
  lib,
  pkgs,
  config,
  inputs,
  osConfig,
  ...
}@args:
let
  inherit (lib) mkIf utils getExe;
  cfg = config.modules.programs.firefox;
in
mkIf cfg.enable {

  home = {
    sessionVariables = {
      BROWSER = "firefox";
    };

    file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      source = inputs.firefox-gnome-theme;
    };
    packages = with pkgs; [ libsForQt5.plasma-browser-integration ];
  };

  # home.file.".mozilla/firefox/default/chrome".source = inputs.firefox-modblur-theme;
  # home.file.".mozilla/firefox/default/chrome".source = pkgs.fetchzip {
  #   url = "https://github.com/datguypiko/Firefox-Mod-Blur/archive/refs/heads/master.zip";
  #   # hash = "sha256-07mpjg7xv5pvsjmfs5nxcznqx59pbmwb9y3b8lnqzn6g4vagazcv";
  #   hash = "sha256-y9oVG+D2Bs5lcXYb14F7yryXCAeFAf0TsDxu79/3JZE=";
  #   postFetch = # bash
  #     ''
  #       file_paths=(
  #         "EXTRA THEMES/MicaForEveryone/acrylic_micaforeveryone.css"
  #         "EXTRA MODS/Auto hide Mods/Popout bookmarks bar/popout_bookmarks_bar_on_hover.css"
  #         "EXTRA MODS/Bookmarks Bar Mods/Remove folder icons from bookmars/remove_folder_icons_from_bookmarks.css"
  #         "EXTRA MODS/Bookmarks Bar Mods/Transparent bookmarks bar/transparent_bookmarks_bar.css"
  #         "EXTRA MODS/Compact extensions menu/Style 2/cleaner_extensions_menu.css"
  #         "EXTRA MODS/Homepage mods/Remove text from homepage shortcuts/remove_homepage_shortcut_title_text.css"
  #         "EXTRA MODS/Icon and Button Mods/Firefox view icon change/firefox_view_icon_change.css"
  #         "EXTRA MODS/Icon and Button Mods/Hide list-all-tabs button/hide_list-all-tabs_button.css"
  #         "EXTRA MODS/Icon and Button Mods/Icons in main menu/icons_in_main_menu.css"
  #         "EXTRA MODS/Icon and Button Mods/Menu icon change/menu_icon_change_to_firefox.css"
  #         "EXTRA MODS/Search Bar Mods/Search box - no border/url_bar_no_border.css"
  #         "EXTRA MODS/Search Bar Mods/Search box - transparent background/search_bar_transparent_background.css"
  #         "EXTRA MODS/Tabs Bar Mods/Colored sound playing tab/colored_soundplaying_tab.css"
  #         "EXTRA MODS/Tabs Bar Mods/Full Width Tabs/tabs_take_full_bar_width.css"
  #         "EXTRA MODS/Tabs Bar Mods/Tabs - transparent background color/transparent_tabs_bg_color.css"
  #       )

  #       for relative_path in "''${file_paths[@]}"; do
  #         src="$out/$relative_path"
  #         cp "$src" "$out/"
  #       done
  #     '';
  # };

  programs.firefox = {
    enable = true;
    # ---- POLICIES ----
    # Check about:policies#documentation for options.
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      InstallAddonsPermission = {
        Default = false;
      };
      BlockAboutAddons = true;
      BlockAboutConfig = true;
      BlockAboutProfiles = true;
      # ---- EXTENSIONS ----
      # Check about:support for extension/add-on ID strings.
      # Valid strings for installation_mode are "allowed", "blocked",
      # "force_installed" and "normal_installed".
    };
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        extensions = with utils.flakePkgs args "firefox-addons"; [
          ublock-origin
          sponsorblock
          bitwarden
          skip-redirect
          i-dont-care-about-cookies
          multi-account-containers
          container-proxy
          container-tab-groups
          container-tabs-sidebar
          containerise
          temporary-containers
        ];

        search = {
          force = true;
          default = "DuckDuckGo";
          engines = {
            "Bing".metaData.hidden = true;
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];

              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "Home-manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "release";
                      value = "master";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
            };
            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://wiki.nixos.org/index.php";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nw" ];
            };
          };
        };
        settings = {
          # For Firefox GNOME theme:
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "browser.tabs.drawInTitlebar" = true;
          ## Firefox gnome theme ## - https://github.com/rafaelmardojai/firefox-gnome-theme/blob/7cba78f5216403c4d2babb278ff9cc58bcb3ea66/configuration/user.js
          # (copied into here because home-manager already writes to user.js)
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
          "browser.uidensity" = 0; # Set UI density to normal
          "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
          "browser.theme.dark-private-windows" = false; # Disable private window dark theme

          # General
          "general.autoScroll" = true;
          "extensions.pocket.enabled" = false;
          # Enable userChrome.css modifications
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # Enable hardware acceleration
          # Firefox only support VAAPI acceleration. This is natively supported
          # by AMD cards but NVIDIA cards need a translation library to go from
          # VDPAU to VAAPI.
          "media.ffmpeg.vaapi.enabled" = osConfig.modules.system.device.gpu.type != null;

          # UI
          "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
          "browser.startup.page" = 3;
          "browser.toolbars.bookmarks.visibility" = "never";

          # QOL
          "browser.aboutConfig.showWarning" = false;
          "doms.forms.autocomplete.formautofill" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "identity.fxaccounts.enabled" = false;
          "signon.management.page.breach-alerts.enabled" = false;

          # Privacy
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "captivedetect.canonicalURL" = "";
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "dom.security.https_only_mode" = true;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "browser.discovery.enabled" = false;
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;
          "network.trr.mode" = 3;
          "network.trr.uri" = "https://dns.quad9.net/dns-query";
          "privacy.trackingprotection.enabled" = true;
          "private.donottrackheader.enabled" = true;
          "private.globalprivacycontrol.enabled" = true;
          "signon.rememberSignons" = false;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.coverage.opt-out" = true;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;

          # Don't report TLS errors to Mozilla
          "security.ssl.errorReporting.enabled" = false;

          # Disable Pocket integration
          "browser.pocket.enabled" = false;
          # "extensions.pocket.enabled" = false;

          # Disable More from Mozilla
          "browser.preferences.moreFromMozilla" = false;

          # Do not show unicode urls https://www.xudongz.com/blog/2017/idn-phishing/
          "network.IDN_show_punycode" = true;

          # Disable screenshots extension
          "extensions.screenshots.disabled" = true;

          # Disable onboarding
          "browser.onboarding.newtour" = "performance,private,addons,customize,default";
          "browser.onboarding.updatetour" = "performance,library,singlesearch,customize";
          "browser.onboarding.enabled" = false;

          # Disable recommended extensions
          "extensions.htmlaboutaddons.discover.enabled" = false;
          # "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # Disable use of WiFi region/location information
          "browser.region.network.scan" = false;
          "browser.region.network.url" = "";
          "browser.region.update.enabled" = false;

          # Disable VPN/mobile promos
          "browser.contentblocking.report.hide_vpn_banner" = true;
          "browser.contentblocking.report.mobile-ios.url" = "";
          "browser.contentblocking.report.mobile-android.url" = "";
          "browser.contentblocking.report.show_mobile_app" = false;
          "browser.contentblocking.report.vpn.enabled" = false;
          "browser.contentblocking.report.vpn.url" = "";
          "browser.contentblocking.report.vpn-promo.url" = "";
          "browser.contentblocking.report.vpn-android.url" = "";
          "browser.contentblocking.report.vpn-ios.url" = "";
          "browser.privatebrowsing.promoEnabled" = false;

        };
        userChrome = ''
          @import "firefox-gnome-theme/userChrome.css";
        '';
        userContent = ''
          @import "firefox-gnome-theme/userContent.css";
        '';
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  desktop.hyprland.keybinds =
    let
      firefox = getExe config.programs.firefox.package;
    in
    [ "SUPER, F2, exec, ${firefox}" ];
}
