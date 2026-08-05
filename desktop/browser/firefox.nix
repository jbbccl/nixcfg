{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.browser.firefox;

  # Betterfox 150 — https://github.com/yokoffing/Betterfox
  betterfoxPrefs = {
    # ── SECUREFOX ──────────────────────────────────────────────

    ## TRACKING PROTECTION
    "browser.contentblocking.category" = "strict";
    "browser.download.start_downloads_in_tmp_dir" = true;
    "browser.uitour.enabled" = false;
    "privacy.globalprivacycontrol.enabled" = true;

    ## OCSP & CERTS / HPKP
    "security.OCSP.enabled" = 0;
    "privacy.antitracking.isolateContentScriptResources" = true;
    "security.csp.reporting.enabled" = false;

    ## SSL / TLS
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "security.tls.enable_0rtt_data" = false;

    ## DISK AVOIDANCE
    "browser.cache.disk.enable" = false;
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "media.memory_cache_max_size" = 65536;
    "browser.sessionstore.interval" = 60000;

    ## SHUTDOWN & SANITIZING
    "privacy.history.custom" = true;
    "browser.privatebrowsing.resetPBM.enabled" = true;

    ## SPECULATIVE LOADING
    "network.http.speculative-parallel-limit" = 0;
    "network.dns.disablePrefetch" = true;
    "network.dns.disablePrefetchFromHTTPS" = true;
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.places.speculativeConnect.enabled" = false;
    "network.prefetch-next" = false;

    ## SEARCH / URL BAR
    "browser.urlbar.trimHttps" = true;
    "browser.urlbar.untrimOnUserInteraction.featureGate" = true;
    "browser.search.separatePrivateDefault.ui.enabled" = true;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.urlbar.groupLabels.enabled" = false;
    "browser.formfill.enable" = false;
    "network.IDN_show_punycode" = true;

    ## HTTPS-ONLY MODE
    "dom.security.https_only_mode" = true;
    "dom.security.https_only_mode_error_page_user_suggestions" = true;

    ## PASSWORDS
    "signon.formlessCapture.enabled" = false;
    "signon.privateBrowsingCapture.enabled" = false;
    "network.auth.subresource-http-auth-allow" = 1;
    "editor.truncate_user_pastes" = false;

    ## EXTENSIONS
    "extensions.enabledScopes" = 5;

    ## HEADERS / REFERERS
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    ## CONTAINERS
    "privacy.userContext.ui.enabled" = true;

    ## VARIOUS
    "pdfjs.enableScripting" = false;

    ## SAFE BROWSING
    "browser.safebrowsing.downloads.remote.enabled" = false;

    ## MOZILLA
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "geo.provider.network.url" = "https://beacondb.net/v1/geolocate";
    "browser.search.update" = false;
    "permissions.manager.defaultsUrl" = "";
    "extensions.getAddons.cache.enabled" = false;

    ## TELEMETRY
    "datareporting.policy.dataSubmissionEnabled" = false;
    "datareporting.healthreport.uploadEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "datareporting.usage.uploadEnabled" = false;

    ## EXPERIMENTS
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    ## CRASH REPORTS
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;

    # ── PESKYFOX ───────────────────────────────────────────────

    ## MOZILLA UI
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "browser.discovery.enabled" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.preferences.moreFromMozilla" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.startup.homepage_override.mstone" = "ignore";
    "browser.aboutwelcome.enabled" = false;
    "browser.profiles.enabled" = true;

    ## THEME ADJUSTMENTS
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.compactmode.show" = true;
    "browser.privateWindowSeparation.enabled" = false;

    ## AI
    "browser.ai.control.default" = "blocked";
    "browser.ml.enable" = false;
    "browser.ml.chat.enabled" = false;
    "browser.ml.chat.menu" = false;
    "browser.tabs.groups.smart.enabled" = false;
    "browser.ml.linkPreview.enabled" = false;

    ## FULLSCREEN NOTICE
    "full-screen-api.transition-duration.enter" = "0 0";
    "full-screen-api.transition-duration.leave" = "0 0";
    "full-screen-api.warning.timeout" = 0;

    ## URL BAR
    "browser.urlbar.trending.featureGate" = false;

    ## NEW TAB PAGE
    "browser.newtabpage.activity-stream.default.sites" = "";
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;

    ## DOWNLOADS
    "browser.download.manager.addToRecentDocs" = false;

    ## PDF
    "browser.download.open_pdf_attachments_inline" = true;

    ## TAB BEHAVIOR
    "browser.bookmarks.openInTabClosesMenu" = false;
    "browser.menu.showViewImageInfo" = true;
    "findbar.highlightAll" = true;
    "layout.word_select.eat_space_to_next_word" = false;
  };

  # Smoothfox: "SMOOTH SCROLLING" (recommended for 90hz+)
  # Alternatives in Smoothfox.js: SHARPEN, INSTANT, NATURAL V3
  smoothfoxPrefs = {
    "apz.overscroll.enabled" = true;
    "general.smoothScroll" = true;
    "general.smoothScroll.msdPhysics.enabled" = true;
    "mousewheel.default.delta_multiplier_y" = 300;
  };

  # Policies shared across all Firefox profiles
  basePolicies = {
    DisableFirefoxStudies = true;
    DisableTelemetry = true;
    DisableFeedbackCommands = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    DisableSetDesktopBackground = true;
    FirefoxHome = {
      SponsoredStories = false;
      SponsoredTopSites = false;
      Stories = false;
    };
    GenerativeAI = {
      Enabled = false;
    };
    ManualAppUpdateOnly = false;
  };

  ublockPolicy = {
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
    };
  };

  searchPolicy = {
    # Clean up bundled search engines + set default
    SearchEngines = {
      PreventInstalls = true;
      Remove = ["Amazon.com" "eBay" "Perplexity"];
      Default = "DuckDuckGo";
    };
  };
in {
  options.desktop.browser.firefox = {
    enable = lib.mkEnableOption "BetterFox privacy & performance tweaks for Firefox";
    smoothfox = lib.mkEnableOption "Smoothfox (Edge-like smooth scrolling, 90hz+)";
    searchEngines = lib.mkEnableOption "clean up bundled search engines (Amazon, eBay, Perplexity) and set DuckDuckGo as default";
    ublock = lib.mkEnableOption "auto-install uBlock Origin via enterprise policy";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences =
        betterfoxPrefs
        // (lib.optionalAttrs cfg.smoothfox smoothfoxPrefs);

      policies =
        basePolicies
        // (lib.optionalAttrs cfg.ublock ublockPolicy)
        // (lib.optionalAttrs cfg.searchEngines searchPolicy);
    };
  };
}
