{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}: let
  cfg = config.desktop.input.fcitx5;
  rimePath = config.desktop.input.rime.shareDir;
in {
  options.desktop.input.fcitx5.enable = lib.mkEnableOption "fcitx5 input method";

  config = lib.mkIf cfg.enable {
    desktop.input.rime.enable = lib.mkDefault true;

    # fcitx5-rime 会把 CapsLock 的“锁定”状态当修饰键一起塞进交给 librime 的
    # 按键掩码里（src/rimestate.cpp: KeyStates{Mod1, CapsLock, Shift, Ctrl, Super}），
    # 而 librime 的 editor/navigator 等绑定是「按键 + 修饰键」精确匹配的，
    # 只对 Shift 做忽略回退、不忽略 Lock。于是开着大写锁定时
    # BackSpace / space / Return / Delete / Escape / 方向键 … 全都匹配不到绑定，
    # rime 返回 noop，fcitx5 就把这些键直接丢给应用程序：预输入删不掉，
    # 反而删掉正文、候选也提交不了。
    # 这里把 CapsLock 从掩码里摘掉即可：全部按键恢复正常，大写字母照常进预输入。
    # 注：若以后把 ascii_composer/switch_key/Caps_Lock 从 noop 改成别的值
    # （想让 CapsLock 切中英），这个补丁会让方向判断失效，需要一并调整。
    nixpkgs.overlays = [
      (final: prev: {
        fcitx5-rime = prev.fcitx5-rime.overrideAttrs (old: {
          postPatch =
            (old.postPatch or "")
            + ''
              substituteInPlace src/rimestate.cpp \
                --replace-fail \
                'KeyStates{KeyState::Mod1, KeyState::CapsLock, KeyState::Shift,' \
                'KeyStates{KeyState::Mod1, KeyState::Shift,'
            '';
        });
      })
    ];

    home-manager.users.${username} = {config, ...}: {
      # ── rime ────────────────────────────────────TODO
      xdg.dataFile."fcitx5/rime" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink rimePath;
      };
      # ── config ──────────────────────────────────
      xdg.configFile."fcitx5/" = {
        force = true;
        recursive = true;
        source = ./config;
      };
      # ── theme ────────────────────────────────────
      xdg.dataFile."fcitx5/themes/custom" = {
        force = true;
        recursive = true;
        source = ./plasma-theme;
      };
    };

    i18n = {
      inputMethod = {
        type = "fcitx5";
        enable = true;
        fcitx5 = {
          waylandFrontend = true;
          addons = with pkgs; [
            fcitx5-rime
            librime-lua
          ];
        };
      };
    };
  };
}
