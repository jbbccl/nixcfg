{lib, ...}: {
  imports = [
    ./base/__base__.nix
    ./dispMgr/__dispMgr__.nix
    ./winMgr/__winMgr__.nix
    ./shell/__shell__.nix
    ./input/__input__.nix
    ./term/__term__.nix
    ./fileMgr/__fileMgr__.nix
    ./browser/__browser__.nix
    ./editor/__editor__.nix
  ];

  config.desktop = lib.mkDefault {
    base.theme = "manual";

    dispMgr = {
      sddm.enable = false;
      greetd.enable = false;
      noctalia-greeter.enable = true;
    };

    winMgr = {
      base.enable = true;
      hypr.enable = false;
      labwc.enable = false;
      mangowc.enable = false;
      niri.enable = true;
    };

    shell = {
      _noctalia.enable = true;

      bar = {
        waybar.enable = false;
        ironbar.enable = false;
      };
      launcher = {
        fuzzel.enable = false;
        rofi.enable = false;
        wofi.enable = false;
      };
      lock.swaylock.enable = false;
      notif = {
        mako.enable = false;
        swaync.enable = false;
      };
      pwmenu.wlogout.enable = false;
      wall.enable = true;
    };

    input = {
      rime.enable = true;
      fcitx5.enable = true;
      ibus.enable = false;
    };

    term = {
      kitty.enable = true;
      alacritty.enable = false;
    };

    fileMgr = {
      # dolphin.enable = true;
      thunar.enable = true;
    };

    editor = {
      vscodium.enable = true;
      zed.enable = true;
    };

    browser = {
      default = "brave";
      firefox = {
        # enable = true;
        smoothfox = true;
        searchEngines = true;
        ublock = true;
      };
      brave.enable = true;
    };
  };
}
