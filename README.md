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
│   │   ├── ...
│   │   └── special-opt.nix  # 主机差异选项
│   └── pc/
│       ├── ...
│       └── special-opt.nix
│
├── core/               # Layer 0: NixOS 内核
│   ├── console.nix     # 控制台 (TTY 字体/键盘)
│   ├── system.nix      # 时区/语言/nix 设置/sudo
│   ├── user.nix        # 用户账户
│   └── nix-ld.nix      # 非 Nix 二进制兼容
│
├── modules/            # Layer 1: NixOS 模块扩展
│   ├── services/       # 系统服务
│   │   ├── audio.nix       # PipeWire
│   │   ├── networking.nix
│   │   ├── ssh.nix
│   │   └── xserver.nix
│   ├── shells/         # Shell 配置
│   │   ├── bash/
│   │   ├── fish/
│   │   └── zsh/
│   ├── development/    # 开发工具链
│   │   ├── git.nix
│   │   ├── go.nix
│   │   ├── rust.nix
│   │   └── ...
│   ├── utilities/      # 系统工具
│   │   ├── neovim/
│   │   └── yazi/
│   └── virtual/        # 虚拟化
│       ├── container/
│       └── hardware/
│
├── desktop/            # Layer 2: 桌面环境
│   ├── options.nix     # 选项定义 (desktop.*)
│   ├── base/           # 基础配置
│   │   ├── theme.nix   # 主题 (GTK/Qt/光标)
│   │   └── fonts.nix   # 字体 (fontconfig)
│   ├── display-manager/ # greetd / sddm
│   ├── window-manager/  # niri / hypr / labwc / mangowc (+ portal.nix)
│   ├── status-bar/      # waybar / noctalia
│   ├── launcher/        # fuzzel / rofi / wofi
│   ├── lock/            # swaylock / wlogout
│   ├── notification/    # mako / swaync
│   ├── input/           # fcitx5 / rime
│   ├── wallpaper/       # waypaper
│   └── session/         # plasma / xfce (与 WM 互斥)
│
├── apps/               # Layer 3: 用户应用
│   ├── services/       # 后台守护进程
│   │   ├── ai/             # litellm
│   │   ├── proxy/          # mihomo
│   │   └── remote-ctrl/    # nginx / wayvnc
│   └── gui/            # 桌面应用
│       ├── misc.nix        # 杂项 GUI 工具
│       ├── broser.nix
│       ├── toolkit.nix     # /opt/toolkit
│       ├── wireshark.nix
│       ├── vm-managers.nix
│       ├── terminal/       # kitty / alacritty
│       └── file-manager/   # dolphin / thunar
│
├── secrets/            # SOPS 加密密钥 (__secrets__.nix)
└── static/             # 静态资源
    └── wallpaper/
```

## 架构

### 分层结构

每层只依赖下层，不反向：

| 层 | 目录 | 内容 |
|---|------|------|
| Layer 0 | `core/` | NixOS 内核配置，所有上层的基础 |
| Layer 1 | `modules/` | 系统级模块扩展（服务、开发环境、Shell、虚拟化） |
| Layer 2 | `desktop/` | 桌面环境（窗口管理器、显示管理器、输入法等） |
| Layer 3 | `apps/` | 用户应用（后台服务 + GUI 应用） |

### 模块原则

- **flake.nix** 为根节点，每个主机（lap/pc）通过 `desktop.*` 选项选择桌面组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*.nix` 索引文件聚合子模块
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个节点所需依赖及配置文件在节点内部完成

### 选项定义 (Option)

自定义选项集中在 `desktop/options.nix`，遵循 **"谁的选项放在谁的文件里"** 原则：

- 选项定义与消费它的模块放在同一目录，而非集中到独立的 `options/` 目录
- 目前仅 `desktop.*` 系列有自定义选项，其他模块直接使用 NixOS/home-manager 标准选项
- `desktop/__desktop__.nix` 同时设置默认值，主机只需在 `special-opt.nix` 中写差异

### 桌面组件

- 通过 `desktop/options.nix` 定义的选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.windowManager` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装（portal.nix 只装 GTK 公共底座）
- `desktop/__desktop__.nix` 设有公共默认值，减少 lap/pc 之间的重复
