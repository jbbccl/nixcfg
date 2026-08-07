{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.browser.firefox;

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
    GenerativeAI.Enabled = false;
    ManualAppUpdateOnly = false;
  };

  # Betterfox user.js → autoconfig (user_pref → pref)
  toAutoConfig = file:
    builtins.replaceStrings ["user_pref"] ["pref"] (builtins.readFile file);
in {
  options.desktop.browser.firefox = {
    enable = lib.mkEnableOption "Firefox + Betterfox";
    smoothfox = lib.mkEnableOption "Smoothfox smooth scrolling (90hz+)";
    searchEngines = lib.mkEnableOption "strip bundled search engines, default DuckDuckGo";
    ublock = lib.mkEnableOption "force-install uBlock Origin";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      autoConfig =
        toAutoConfig ./betterfox.user.js
        + lib.optionalString cfg.smoothfox (toAutoConfig ./smoothfox.user.js);
      policies =
        basePolicies
        // lib.optionalAttrs cfg.ublock {
          ExtensionSettings."uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
        }
        // lib.optionalAttrs cfg.searchEngines {
          SearchEngines = {
            PreventInstalls = true;
            Remove = ["Amazon.com" "eBay" "Perplexity"];
            Default = "DuckDuckGo";
          };
        };
    };
  };
}
