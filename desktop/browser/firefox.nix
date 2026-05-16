{ config, lib, pkgs, ... }:
let
  cfg = config.desktop.browser.firefox;

  betterfox-src = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "150.0";
    hash = "sha256-elGsTJu+eSzyS9IAnQuEppyhdDkRQwggUP7aypuXRh8=";
  };

  # Parse user_pref("key", value) lines from BetterFox user.js
  # Handles: bool (true/false), int (0, 60000), string ("strict", "0.15", "data:,")
  parseUserJs = text:
    let
      inherit (builtins) match filter map head length elemAt isNull;
      lines = lib.splitString "\n" text;
      userPrefLine = line:
        let m = match ''[[:space:]]*user_pref\("([^"]+)",[[:space:]]*(.+)\);.*'' line;
        in if m == null then null else {
          name = elemAt m 0;
          value = let raw = elemAt m 1; in
            if raw == "true" then true
            else if raw == "false" then false
            else if match ''-?[0-9]+'' raw != null then lib.toInt raw
            else if match ''"(.*)"'' raw != null then
              head (match ''"(.*)"'' raw)
            else raw;
        };
      entries = filter (x: x != null) (map userPrefLine lines);
    in builtins.listToAttrs entries;

  betterfoxPrefs = parseUserJs (builtins.readFile "${betterfox-src}/user.js");

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
      Remove = [ "Amazon.com" "eBay" "Perplexity" ];
      Default = "DuckDuckGo";
    };
  };

in {
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      preferences = betterfoxPrefs
        // (lib.optionalAttrs cfg.smoothfox smoothfoxPrefs);

      policies = basePolicies
        // (lib.optionalAttrs cfg.ublock ublockPolicy)
        // (lib.optionalAttrs cfg.searchEngines searchPolicy);
    };
  };
}
