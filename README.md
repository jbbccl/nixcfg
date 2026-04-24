# 项目规范

**项目基础架构，和项目结构同步更改**

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── host/               # 主机配置
│   ├── common.nix      # 共享配置聚合
│   ├── lap/
│   └── pc/
├── core/               # 核心系统设置
│   ├── system.nix      # 时区 / nix 设置 / sudo
│   ├── font-i8n.nix    # 字体 / locale
│   ├── nix-ld.nix      # 非 Nix 二进制兼容
│   ├── tty-xkb.nix     # TTY 键盘 / 控制台
│   └── user.nix        # 用户账户
├── modules/            # 功能模块
│   ├── options/         # 选项定义 (desktop.*)
│   ├── development/     # 开发环境
│   │   └── flake-c-py/
│   ├── services/        # 系统服务
│   │   ├── audio.nix    # PipeWire
│   │   ├── networking.nix
│   │   ├── ssh.nix
│   │   ├── proxy/
│   │   └── AI/
│   ├── shells/          # Shell 配置
│   │   ├── fish/
│   │   └── zsh/
│   ├── utilities/       # 工具
│   │   ├── neovim/
│   │   └── yazi/
│   └── virtual/         # 虚拟化
│       ├── container/
│       └── hardware/
├── desktop/            # 桌面环境
│   ├── theme.nix        # 主题 (GTK/Qt/光标)
│   ├── display-manager/ # greetd / sddm
│   ├── window-manager/  # niri / hypr / labwc / mangowc (+ portal.nix)
│   ├── status-bar/      # waybar / noctalia
│   ├── launcher/        # fuzzel / rofi / wofi
│   ├── lock/            # swaylock / wlogout
│   ├── notification/    # mako / swaync
│   ├── input/           # fcitx5 / rime
│   ├── wallpaper/       # waypaper
│   └── session/         # plasma / xfce (与 WM 互斥)
├── apps/               # 应用
│   ├── gui.nix
│   ├── broser.nix
│   ├── toolkit.nix
│   ├── wireshark.nix
│   ├── vm-managers.nix
│   ├── terminal/        # kitty / alacritty
│   └── file-manager/    # dolphin / thunar
├── secrets/            # SOPS 加密密钥
└── static/             # 静态资源
    └── wallpaper/
```

## 架构

- **flake.nix** 为根节点，每个主机（lap/pc）通过 `desktop.*` 选项选择桌面组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*.nix` 索引文件聚合子模块
- 桌面组件通过 `modules/options/desktop.nix` 定义的选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.windowManager` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装（portal.nix 只装 GTK 公共底座）
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个节点所需依赖及配置文件在节点内部完成
