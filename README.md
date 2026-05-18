# 非常模块化的nixos 配置

赛博积木这一块    
每个文件摘出去就能用, 例如fcitx输入法配置和WM配置.
```
desktop/input
desktop/winMgr
```
可以直接import到你的config里
```nix
imports = [ 
	./input/__input__.nix
	./winMgr/__winMgr__.nix
];
# 选择启用的桌面
config.desktop.winMgr.list = [ "niri" ];
```
原configuration存放在`/nixcfg/host`下  

`secrets/__secrets__.nix:4`依赖sops解密服务的模块总开关, 没有密钥时关闭

# (agent readme)项目规范

**项目基础架构，和项目结构同步更改**

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── lib/                # 工具库
│   ├── default.nix     # 聚合导出 (nixpkgsOverlays + validators + helpers)
│   ├── overlays.nix    # 三分支 nixpkgs overlay (stable/unstable/master)
│   ├── helpers.nix     # mkNullOrEnum, mkConfigDir, mkHomeDir
│   └── validators.nix  # 类型校验扩展
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
│   ├── __desktop__.nix # enable 开关 + imports + 默认值
│   ├── base/           # 基础配置
│   │   ├── theme.nix   # 主题 (GTK/Qt/光标)
│   │   └── fonts.nix   # 字体 (fontconfig)
│   ├── dispMgr/        # greetd / sddm
│   ├── winMgr/         # niri / hypr / labwc / mangowc
│   ├── bar/            # waybar / noctalia
│   ├── launcher/       # fuzzel / rofi / wofi
│   ├── lock/           # swaylock
│   ├── notif/          # mako / swaync
│   ├── term/           # kitty / alacritty
│   ├── fileMgr/        # dolphin / thunar
│   ├── browser/        # firefox
│   ├── input/          # fcitx5 / rime
│   └── wallpaper/      # waypaper
│
├── apps/               # Layer 3: 用户应用
│   ├── __apps__.nix    # 选项 (services/gui/cli/containers) + 默认值
│   ├── services/       # 后台守护进程
│   │   ├── ai/             # litellm + hermes-agent + opencode
│   │   ├── proxy/          # mihomo
│   │   └── remote-ctrl/    # nginx + wayvnc
│   ├── gui/            # 桌面应用
│   │   ├── misc.nix        # 杂项 GUI 工具
│   │   ├── broser.nix
│   │   ├── toolkit.nix     # /opt/toolkit
│   │   ├── wireshark.nix
│   │   └── vm-managers.nix
│   ├── cli/            # 命令行工具
│   │   └── misc.nix
│   └── containers/     # 容器化应用
│       ├── __containers__.nix  # 选项 + 导入 + mkDefault 默认值
│       ├── entrypoint.sh       # 容器入口 dbus/PATH/XDG 初始化
│       ├── environment         # 容器内环境变量
│       ├── toolkit-profile.sh  # login shell profile
│       ├── debian/            # Debian 每日容器
│       │   ├── default.nix     # 模块 (构建服务 + CLI)
│       │   └── Dockerfile
│       └── kali/              # Kali 每日容器
│           ├── default.nix     # 模块 (构建服务 + CLI)
│           └── Dockerfile
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
| Layer 3 | `apps/` | 用户应用（后台服务 + GUI 应用 + 容器） |

### 模块原则

- **flake.nix** 为根节点，每个主机（lap/pc）通过 `desktop.*` 选项选择桌面组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*.nix` 索引文件聚合子模块
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个节点所需依赖及配置文件在节点内部完成

### 选项定义 (Option)

**分散定义**：每个子模块自包含 option 定义 + config 逻辑，删除 import 即清理干净。

| 文件 | 选项 | 类型 |
|------|------|------|
| `desktop/__desktop__.nix` | `desktop.enable` | 顶层开关 |
| `desktop/winMgr/__winMgr__.nix` | `desktop.winMgr.list` | `mkNullOrListEnum` |
| `desktop/bar/__bar__.nix` | `desktop.bar.list` | `mkNullOrListEnum` |
| `desktop/dispMgr/__dispMgr__.nix` | `desktop.dispMgr.select` | `mkNullOrEnum` |
| `desktop/launcher/__launcher__.nix` | `desktop.launcher.select` | `mkNullOrEnum` |
| `desktop/lock/__lock__.nix` | `desktop.lock.select` | `mkNullOrEnum` |
| `desktop/notif/__notif__.nix` | `desktop.notif.select` | `mkNullOrEnum` |
| `desktop/term/__term__.nix` | `desktop.term.select` | `mkNullOrEnum` |
| `desktop/fileMgr/__fileMgr__.nix` | `desktop.fileMgr.list` | `mkNullOrListEnum` |
| `desktop/browser/__browser__.nix` | `desktop.browser.firefox.*` | `mkEnableOption` |
| `modules/__modules__.nix` | `modules.*` | 模块大类开关 |
| `apps/__apps__.nix` | `apps.*` | 应用大类开关 |
| `apps/containers/__containers__.nix` | `apps.containers.*` | 容器实例开关 |

- `desktop.*` 使用 `mkNullOrEnum` / `mkNullOrListEnum` helper
- `modules.*` 和 `apps.*` 使用标准 `mkEnableOption`
- `__desktop__.nix` 集中设置 `lib.mkDefault` 默认值，主机只需在 `special-opt.nix` 中写差异

### 桌面组件

- 通过 `desktop.*.list` / `desktop.*.select` 选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.winMgr.list` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
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

### 为什么手动维护

- **删除即生效**：移除一行 import 注释掉模块，不再需要找文件删
- **加载顺序可控**：import 列表顺序决定合并顺序，后续模块可覆写前置模块
- **依赖显式可见**：每个模块引了什么一目了然
- **无隐性生效**：新建一个 `.nix` 文件不会自动激活，必须手动加入索引

### 约定

1. **两层索引**：aggregate（`__*__.nix`）负责 imports + enable 开关 + mkDefault 默认值；leaf 文件只写 `config = lib.mkIf config.xxx.enable { ... }`
2. **选项就近定义**：选项放在消费它的 aggregate 文件中（`desktop/winMgr/__winMgr__.nix` 定义 `desktop.winMgr.list`）
3. **mkDefault 默认值**：aggregate 层用 `lib.mkDefault true` 设默认，host 在 `special-opt.nix` 中覆写
4. **条件激活**：所有 leaf 模块首行必须是 `lib.mkIf config.xxx.enable`
5. **最小改动原则**: 每次增加功能只用简洁的语法造成最小的改动, 删除\简化则不受约束.
### lib/helpers.nix 函数一览
`lib/helpers.nix` 提供以下可复用函数，被全项目引用：

| 函数 | 用途 | 出现次数 |
|------|------|----------|
| `mkNullOrEnum` | nullable enum option (单选) | 6 |
| `mkNullOrListEnum` | nullable list-of-enum option (多选) | 3 |
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
nix-collect-garbage -d
sudo nix-collect-garbage -d
```
