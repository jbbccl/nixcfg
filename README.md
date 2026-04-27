# 项目规范

**项目基础架构，和项目结构同步更改**

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── lib/                # 工具库
│   ├── default.nix     # 聚合导出 (nixpkgsOverlays + validators)
│   ├── overlays.nix    # 三分支 nixpkgs overlay (stable/unstable/master)
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
│   ├── __desktop__.nix # 选项 + 默认值 + 聚合入口
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

自定义选项在 `desktop/__desktop__.nix` 中定义，遵循 **"谁的选项放在谁的文件里"** 原则：

- 使用 `mkDesktopOption` / `mkDesktopListOption` helper 简化 `nullOr (enum ...)` 定义
- 目前仅 `desktop.*` 系列有自定义选项，其他模块直接使用 NixOS/home-manager 标准选项
- `desktop/__desktop__.nix` 同时设置默认值，主机只需在 `special-opt.nix` 中写差异

### 桌面组件

- 通过 `desktop/__desktop__.nix` 定义的选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.windowManager` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装（portal.nix 只装 GTK 公共底座）
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
2. **选项就近定义**：选项放在消费它的 aggregate 文件中（如 `modules/__modules__.nix` 定义 `modules.services`）
3. **mkDefault 默认值**：aggregate 层用 `lib.mkDefault true` 设默认，host 在 `special-opt.nix` 中覆写
4. **条件激活**：所有 leaf 模块首行必须是 `lib.mkIf config.xxx.enable`

### 桌面选项 helper

`desktop/__desktop__.nix` 使用两个 helper 避免 `lib.mkOption` 重复样板：

```nix
mkDesktopOption = desc: values: lib.mkOption {
  type = lib.types.nullOr (lib.types.enum values);
  default = null;
  description = desc;
};
mkDesktopListOption = desc: values: lib.mkOption {
  type = lib.types.nullOr (lib.types.listOf (lib.types.enum values));
  default = null;
  description = desc;
};
```

用法一行搞定：
```nix
bar = mkDesktopOption "status bar" [ "waybar" "noctalia" ];
windowManager = mkDesktopListOption "window managers" [ "niri" "labwc" "hypr" "mangowc" ];
```

### 索引文件命名

| 索引文件 | 所在目录 | 聚合内容 |
|----------|----------|----------|
| `core/__core__.nix` | core/ | console, system, user, nix-ld |
| `modules/__modules__.nix` | modules/ | services/dev/shells/utilities/virtual 的 enable 开关 + 子 aggregate |
| `modules/services/__services__.nix` | modules/services/ | audio, networking, ssh, xserver |
| `modules/development/__development__.nix` | modules/development/ | git, languages (c-cpp/go/java/javascript/python/rust) |
| `desktop/__desktop__.nix` | desktop/ | options + 所有桌面组件的 enable 开关 + 默认值 |
| `apps/__apps__.nix` | apps/ | services/gui/cli 的 enable 开关 + 子 aggregate |
| `secrets/__secrets__.nix` | secrets/ | SOPS 解密配置 |

### 添加新模块的步骤

以添加 `modules/development/lua.nix` 为例：

**Step 1 — 写 leaf 文件**

```nix
# modules/development/lua.nix
{ config, lib, pkgs, ... }:
lib.mkIf config.development.languages != [] && builtins.elem "lua" config.development.languages {
  environment.systemPackages = with pkgs; [ lua ];
}
```

**Step 2 — 注册语言枚举**（编辑 `modules/development/__development__.nix`）

```nix
type = lib.types.listOf (lib.types.enum [
  "c-cpp" "go" "java" "javascript" "lua" "python" "rust"
]);
```

**Step 3 — 加入 import 列表**（同一文件）

```nix
imports = [
  ./git.nix
  ./c-cpp.nix
  ./javascript.nix
  ./lua.nix          # ← 新增
  ./python.nix
  ./rust.nix
  ./go.nix
  ./java.nix
];
```

**Step 4 — 主机启用**（编辑 `host/lap/special-opt.nix` 或 `host/pc/special-opt.nix`）

```nix
development.languages = [ "c-cpp" "javascript" "lua" "python" "rust" ];
```

### 禁用模块

**禁用整个模块组**（如停用虚拟化）：

```nix
# host/lap/special-opt.nix
modules.virtualization = false;
```

**禁用单个组件**（如不装 waybar）：

```nix
# host/lap/special-opt.nix
desktop.bar = null;
```

**临时注释掉 import**（不删文件，只停用）：

```nix
imports = [
  ./services/__services__.nix
  # ./virtual/__virtual__.nix  # 暂时禁用
  ./utilities/__utilities__.nix
];
```

### Import 链路

```
flake.nix
  └─ host/lap/configuration.nix
       ├─ hardware-configuration.nix
       ├─ driver.nix
       ├─ boot.nix
       ├─ special-opt.nix         ← 主机差异覆写（最后导入，优先级最高）
       └─ host/common.nix
            ├─ core/__core__.nix
            │    ├─ console.nix
            │    ├─ nix-ld.nix
            │    ├─ system.nix
            │    └─ user.nix
            ├─ modules/__modules__.nix
            │    ├─ development/__development__.nix
            │    ├─ services/__services__.nix
            │    ├─ shells/__shells__.nix
            │    ├─ virtual/__virtual__.nix
            │    └─ utilities/__utilities__.nix
            ├─ desktop/__desktop__.nix
            │    ├─ base/__base__.nix
            │    ├─ display-manager/__displayMgr__.nix
            │    ├─ window-manager/__winMgr__.nix
            │    ├─ status-bar/__bar__.nix
            │    ├─ launcher/__launcher__.nix
            │    └─ ...
            ├─ apps/__apps__.nix
            │    ├─ services/__services__.nix
            │    ├─ gui/__gui__.nix
            │    └─ cli/__cli__.nix
            └─ secrets/__secrets__.nix
```
