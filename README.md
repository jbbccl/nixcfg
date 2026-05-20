# 非常模块化的nixos 配置

赛博积木这一块    
每个目录摘出去就能用, 例如fcitx输入法配置和WM配置.
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

## 使用整个配置

原configuration存放在`/nixcfg/host`下  

`secrets/__secrets__.nix`管理 sops 密钥和 age 配置

---

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
│   ├── __core__.nix    # enable 开关 + imports + 默认值
│   ├── console.nix     # 控制台 (TTY 字体/键盘)
│   ├── system.nix      # 时区/语言/nix 设置/sudo
│   ├── user.nix        # 用户账户
│   └── nix-ld.nix      # 非 Nix 二进制兼容
│
├── modules/            # Layer 1: NixOS 模块扩展
│   ├── __modules__.nix     # enable 开关 + imports + lib.mkDefault 默认值
│   ├── development/        # 开发工具链
│   │   ├── __development__.nix  # languages option + imports
│   │   ├── git.nix
│   │   ├── go.nix
│   │   ├── rust.nix
│   │   └── ...
│   ├── services/           # 系统服务
│   │   ├── __services__.nix    # enable 开关 + imports
│   │   ├── audio.nix           # PipeWire (自声明 enable)
│   │   ├── ssh.nix             # SSH + GitHub 密钥
│   │   └── xserver.nix         # X11 xkb
│   ├── shells/             # Shell 配置
│   │   ├── __shells__.nix      # enable 开关 + imports + 默认 shell
│   │   ├── bash/
│   │   ├── fish/
│   │   └── zsh/
│   ├── virtual/            # 虚拟化
│   │   ├── __virtual__.nix     # enable 开关 + imports
│   │   ├── container/
│   │   └── hardware/
│   └── utilities/          # 系统工具
│       ├── __utilities__.nix   # enable 开关 + imports
│       ├── neovim/
│       ├── yazi/
│       └── basic-tools.nix
│
├── desktop/            # Layer 2: 桌面环境
│   ├── __desktop__.nix # enable 开关 + imports + lib.mkDefault 默认值
│   ├── base/           # 基础配置
│   │   ├── __base__.nix
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
│   ├── __apps__.nix    # enable 开关 + imports + lib.mkDefault 默认值
│   ├── services/       # 后台守护进程
│   │   ├── __services__.nix # enable 开关 + imports
│   │   ├── ai/             # litellm + hermes-agent + opencode
│   │   │   └── __ai__.nix  # enable 开关 + sops 密钥 + 子模块默认值
│   │   ├── proxy/          # mihomo
│   │   │   └── __proxy__.nix   # enable 开关 + imports
│   │   ├── ingress/        # cloudflared + nginx
│   │   │   └── __ingress__.nix # enable/domain/port 选项 + sops 密钥
│   │   └── remote-ctrl/    # nginx + wayvnc
│   │       └── __remote-ctrl__.nix  # enable 开关 + imports
│   ├── toolkits/       # /opt/toolkit 工具集
│   │   └── __toolkits__.nix    # enable 开关 + imports
│   ├── game/           # 游戏
│   │   ├── __game__.nix      # enable 开关 + imports
│   │   └── steam.nix         # Steam (自声明 enable)
│   └── containers/     # 容器化应用
│       └── __containers__.nix    # enable 开关 + imports
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
| Layer 3 | `apps/` | 用户应用（后台服务 + 工具集 + 游戏 + 容器） |

### 模块原则

- **flake.nix** 为根节点，每个主机（lap/pc）通过 `desktop.*` 选项选择桌面组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*.nix` 索引文件聚合子模块
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个节点所需依赖及配置文件在节点内部完成

### 选项定义 (Option)

**分散定义**：每个子模块自包含 option 定义 + config 逻辑，删除 import 即清理干净。

| 文件 | 选项 | 类型 |
|------|------|------|
| `apps/__apps__.nix` | `apps.enable` / `apps.services.*.enable` / `apps.game.*.enable` / `apps.toolkits.enable` 默认值 | |
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
| `modules/__modules__.nix` | `modules.enable` + 所有子模块 `lib.mkDefault` 默认值 | |
| `modules/development/__development__.nix` | `modules.development.languages` | `mkNullOrListEnum` |
| `apps/services/ai/__ai__.nix` | `apps.services.ai.enable` | `mkEnableOption` |
| `apps/services/ingress/__ingress__.nix` | `apps.services.ingress.enable` / `domain` / `port` | `mkEnableOption` + `mkOption` |
| `apps/services/proxy/mihomo/__mihomo__.nix` | `apps.services.proxy.mihomo.enable` | `mkEnableOption` |

- `desktop.*` 使用 `mkNullOrEnum` / `mkNullOrListEnum` helper
- `modules.*` 和 `apps.*` 使用标准 `mkEnableOption`
- `__desktop__.nix`、`__apps__.nix`、`__modules__.nix` 集中设置 `lib.mkDefault` 默认值，主机只需在 `special-opt.nix` 中写差异

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

### 约定

1. `__*__.nix`代表一个摘出去能直接用的模块, 若导入的子模块不以`__xxx__.nix`命名则不需要考虑其的独立性,如`apps/services/ai` 下子模块全都依赖`__ai__.nix`中定义的密钥

2. **自己声明选项**：每个带有config的模块, (包括不需要考虑再分的模块) 使用如下写法.
at `apps/services/proxy/aaa/aaa.nix`
```nix
{ config, lib, pkgs, ... }:
let
  cfg = config.apps.services.aaa; # 与路径对应
in
{
  options.apps.services.aaa.enable = lib.mkEnableOption "..."; # bool用enable\ enum用select \ list 用list
  config = lib.mkIf cfg.enable {
    ...
  };
}
```
并在`__apps__.nix` `__desktop__.nix` `__modules__.nix`中设置默认值.每个 `__*__.nix` 自声明 option，父模块只设 `lib.mkDefault` 默认值.

3. **最小改动原则**: 每次增加功能只用简洁的语法造成最小的改动, 删除\简化则不受约束.比如能在变量里改动一处,就不要改动多处

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
