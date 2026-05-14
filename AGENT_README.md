# 项目规范

**项目基础架构，和项目结构同步更改**

## 项目结构树

```
nixcfg/
├── flake.nix              # 入口
├── flake.lock
├── .sops.yaml
├── lib/                   # 工具库
│   ├── default.nix        # 聚合导出 (nixpkgsOverlays + validators + helpers)
│   ├── overlays.nix       # 三分支 nixpkgs overlay (stable/unstable/master)
│   ├── helpers.nix        # mkNullOrEnum, mkNullOrListEnum, mkConfigDir, mkHomeDir
│   └── validators.nix     # 类型校验扩展
├── host/                  # 主机配置
│   ├── common.nix         # 共享配置聚合
│   ├── lap/
│   │   ├── configuration.nix
│   │   ├── boot.nix
│   │   ├── driver.nix
│   │   └── hardware-configuration.nix
│   └── pc/
│       ├── configuration.nix
│       ├── boot.nix
│       ├── driver.nix
│       └── hardware-configuration.nix
│
├── core/                  # Layer 0: NixOS 内核
│   ├── __core__.nix       # 聚合入口
│   ├── console.nix        # 控制台 (TTY 字体/键盘)
│   ├── system.nix         # 时区/语言/nix 设置/sudo
│   ├── user.nix           # 用户账户
│   └── nix-ld.nix         # 非 Nix 二进制兼容
│
├── modules/               # Layer 1: NixOS 模块扩展
│   ├── __modules__.nix    # 选项 (modules.*) + 默认值 + 聚合导入
│   ├── services/
│   │   ├── __services__.nix
│   │   ├── audio.nix      # PipeWire
│   │   ├── networking.nix
│   │   ├── ssh.nix
│   │   └── xserver.nix
│   ├── shells/
│   │   ├── __shells__.nix
│   │   ├── bash/
│   │   ├── fish/
│   │   └── zsh/
│   ├── development/
│   │   ├── __development__.nix
│   │   ├── git.nix
│   │   ├── c-cpp.nix
│   │   ├── go.nix
│   │   ├── java.nix
│   │   ├── javascript.nix
│   │   ├── python.nix
│   │   └── rust.nix
│   ├── utilities/
│   │   ├── __utilities__.nix
│   │   ├── basic-tools.nix
│   │   ├── neovim/
│   │   └── yazi/
│   └── virtual/
│       ├── __virtual__.nix
│       ├── container/
│       └── hardware/
│
├── desktop/               # Layer 2: 桌面环境（DE 标配组件）
│   ├── __desktop__.nix    # 选项 + 默认值 + 聚合入口
│   ├── base/
│   │   ├── __base__.nix
│   │   ├── theme.nix      # 主题 (GTK/Qt/光标)
│   │   └── fonts.nix      # 字体 (fontconfig)
│   ├── display-manager/   # greetd / sddm
│   │   ├── __displayMgr__.nix
│   │   ├── greetd/
│   │   └── sddm/
│   ├── window-manager/    # niri / hypr / labwc / mangowc
│   │   ├── __winMgr__.nix
│   │   ├── niri/
│   │   ├── hypr/
│   │   ├── labwc/
│   │   └── mangowc/
│   ├── status-bar/        # waybar / noctalia
│   │   ├── __bar__.nix
│   │   ├── waybar/
│   │   └── noctalia/
│   ├── launcher/          # fuzzel / rofi / wofi
│   │   ├── __launcher__.nix
│   │   ├── fuzzel/
│   │   ├── rofi/
│   │   └── wofi/
│   ├── lock/              # swaylock / wlogout
│   │   ├── __lock__.nix
│   │   ├── swaylock/
│   │   └── wlogout/
│   ├── notification/      # mako / swaync
│   │   ├── __notification__.nix
│   │   ├── mako/
│   │   └── swaync/
│   ├── terminal/          # kitty / alacritty
│   │   ├── __terminal__.nix
│   │   ├── kitty.nix
│   │   ├── alacritty.nix
│   │   └── config/
│   ├── file-manager/      # dolphin / thunar
│   │   ├── __fileMgr__.nix
│   │   ├── dolphin.nix
│   │   └── thunar.nix
│   ├── input/             # fcitx5 / rime
│   │   ├── __input__.nix
│   │   ├── config/
│   │   └── share/
│   ├── wallpaper/         # waypaper
│   │   └── __wallpaper__.nix
│   └── session/           # plasma / xfce (与 WM 互斥)
│       ├── default.nix
│       ├── plasma/
│       └── xfce/
│
├── apps/                  # Layer 3: 用户应用（非 DE 标配）
│   ├── __apps__.nix       # 选项 (services/gui/cli/containers) + 默认值
│   ├── services/
│   │   ├── __services__.nix
│   │   ├── ai/            # litellm + hermes-agent + opencode
│   │   │   └── __ai__.nix
│   │   ├── proxy/         # mihomo
│   │   │   └── __proxy__.nix
│   │   └── remote-ctrl/   # nginx + wayvnc
│   │       ├── __remote-ctrl__.nix
│   │       ├── nginx.nix
│   │       ├── vnc.nix
│   │       └── wayvnc/
│   ├── gui/
│   │   ├── __gui__.nix
│   │   ├── claude-haha/   # Claude Code Haha (deb 提取)
│   │   └── toolkits/      # misc / broser / wireshark / vm-managers
│   │       ├── __toolkits__.nix
│   │       ├── misc.nix
│   │       ├── broser.nix
│   │       ├── wireshark.nix
│   │       └── vm-managers.nix
│   ├── cli/
│   │   ├── __cli__.nix
│   │   └── misc.nix
│   └── containers/
│       ├── __containers__.nix
│       ├── entrypoint.sh
│       ├── environment
│       ├── toolkit-profile.sh
│       ├── debian/
│       │   ├── default.nix
│       │   └── Dockerfile
│       └── kali/
│           ├── default.nix
│           └── Dockerfile
│
├── secrets/               # SOPS 加密密钥
│   ├── __secrets__.nix
│   ├── api_keys.yaml
│   ├── ssh_keys.yaml
│   └── token.yaml
└── static/                # 静态资源
    └── wallpaper/
```

## 架构

### 分层标准

**desktop/ vs apps/ 的划分依据：主流 DE 是否标配该组件。**

| DE 标配（→ desktop/） | 非标配（→ apps/） |
|---|---|
| 窗口管理器、状态栏、显示管理器、启动器 | 浏览器、编辑器、IDE |
| 终端、文件管理器、锁屏、通知 | AI 服务、代理、远程控制 |
| 输入法、壁纸、主题/字体 | 网络工具 (wireshark)、虚拟机 |

如果一个组件 KDE / GNOME / XFCE 都自带，它就是 desktop/。

### 分层结构

每层只依赖下层，不反向：

| 层 | 目录 | 内容 |
|---|------|------|
| Layer 0 | `core/` | NixOS 内核配置，所有上层的基础 |
| Layer 1 | `modules/` | 系统级模块扩展（服务、开发环境、Shell、虚拟化） |
| Layer 2 | `desktop/` | 桌面环境（DE 标配组件） |
| Layer 3 | `apps/` | 用户应用（后台服务 + GUI 应用 + 容器） |

### 模块原则

- **flake.nix** 为根节点，每个主机（lap/pc）通过 `desktop.*` 选项选择桌面组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*.nix` 索引文件聚合子模块
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个节点所需依赖及配置文件在节点内部完成

### 选项定义 (Option)

自定义选项遵循 **"谁的选项放在谁的文件里"** 原则：

| 文件 | 选项 | 类型 |
|------|------|------|
| `desktop/__desktop__.nix` | `desktop.*` | 桌面组件选择 (WM/bar/DM/launcher/terminal/fileManager 等) |
| `modules/__modules__.nix` | `modules.*` | 模块大类开关 |
| `apps/__apps__.nix` | `apps.*` | 应用大类开关 |
| `apps/containers/__containers__.nix` | `-` | 不在顶层,不配置开关 |

- 统一使用 `mkNullOrEnum` / `mkNullOrListEnum` helper
- 父级 aggregate 文件同时设置 `lib.mkDefault` 默认值，主机只需在 `configuration.nix` 中写差异

### 桌面组件

- 通过 `desktop/__desktop__.nix` 定义的选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.windowManager`、`desktop.bar`、`desktop.fileManager` 是列表类型：可同时启用多个，无需重构
- `desktop.terminal`、`desktop.launcher` 等是单选枚举：同一时刻只有一个终端/启动器
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装
- `desktop/__desktop__.nix` 设有公共默认值，减少 lap/pc 之间的重复

### 三分支 nixpkgs overlay

`lib/overlays.nix` 将 3 个 nixpkgs 分支注入到 package set：

- `pkgs.stable`  — nixos-25.11（稳定版）
- `pkgs.unstable` — nixos-unstable（滚动更新）
- `pkgs.master`  — master（最新提交）

全部开启 `allowUnfree = true`。在任意 NixOS/HM 模块中直接用 `pkgs.stable.firefox`、`pkgs.unstable.neovim` 等语法精确选择版本。

## 手动维护模块规范

本项目的模块导入**全部手动维护**，不使用 `imports = builtins.attrValues (builtins.readDir ./.)` 等自动发现。每个模块目录内有一个 `__<name>__.nix` 索引文件，显式列出所有子模块的 import 路径。

- **删除即生效**：移除一行 import 注释掉模块，不再需要找文件删
- **加载顺序可控**：import 列表顺序决定合并顺序，后续模块可覆写前置模块
- **依赖显式可见**：每个模块引了什么一目了然
- **无隐性生效**：新建一个 `.nix` 文件不会自动激活，必须手动加入索引

### lib/helpers.nix 函数一览
`lib/helpers.nix` 提供以下可复用函数，被全项目引用：

| 函数 | 用途 | 出现次数 |
|------|------|----------|
| `mkNullOrEnum` | nullable enum option | 5 |
| `mkNullOrListEnum` | nullable list-of-enum option | 3 |
| `mkConfigDir` | xdg.configFile 目录绑定 (`force/recursive/source`) | 10+ |
| `mkHomeDir` | home.file 目录绑定 | 2 |

备忘
```sh
sudo nixos-rebuild switch --flake ~/nixcfg#lap --option substitute false
nix flake check ~/nixcfg
nix flake update
nix flake lock --update-input noctalia

nix profile wipe-history --profile /home/e/.local/state/nix/profiles/profile --older-than 1d
sudo systemctl restart nix-daemon
sudo nix-collect-garbage -d && nix-collect-garbage -d
```
