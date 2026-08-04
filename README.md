# 模块化的nixos 配置

赛博积木这一块   

## 使用整个配置

原configuration存放在`/nixcfg/host`下  

`secrets/__secrets__.nix`管理 sops 密钥和 age 配置

---

# (agent readme)项目规范

**项目基础架构，和项目结构同步更改**

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

- **flake.nix** 为根节点，每个主机（lap/pc）通过选项选择组件
- 每个目录对应一个 **NixOS 模块**，通过 `__*__.nix` 索引文件聚合子模块
- 非根节点通过 `import` 连接，任意节点移除不会对系统正常运行造成影响
- 每个以`__*__.nix`为入口的节点所需依赖及配置文件在节点内部完成, 禁用模块即禁用依赖
- 每个子模块自包含 option 定义, 删除 import 即清理干净, 详见 `###约定 2. 自己声明选项` 

### 约定

0. 本项目的模块导入**全部手动维护**，不使用 `imports = builtins.attrValues (builtins.readDir ./.)` 等自动发现。每个模块目录内有一个 `__<name>__.nix` 索引文件，显式列出所有子模块的 import 路径。

1. `__*__.nix`代表一个摘出去能直接用的模块, 若导入的子模块不以`__*__.nix`命名则不需要考虑其独立性,如`apps/services/ai` 下子模块不以`__*__.nix`命名, 可以全都依赖`__ai__.nix`中定义的密钥

2. **自己声明选项**：每个带有config的模块, (包括不需要考虑再分的模块) 使用如下写法.
	at `apps/services/proxy/aaa/aaa.nix`
	```nix
	{ config, lib, pkgs, ... }:
	let
	cfg = config.apps.services.aaa; # 与路径对应
	in
	{
	options.apps.services.aaa.enable = lib.mkEnableOption "...";
	config = lib.mkIf cfg.enable {
		...
	};
	}
	```
	并在`__apps__.nix` `__desktop__.nix` `__modules__.nix`中设置默认值.每个 `__*__.nix` 自声明 option，父模块只设 `lib.mkDefault` 默认值.

3. 对2的补充, 模块对外提供的option目前有以下三种, 启用 .enable | 单选 select | 多选 list ,
	在__desktop__.nix中,为了方便批量选择和选择防止冲突使用多选和单选方法, 每个叶子模块仍用.enable设置boolean, 在父节点(.list option定义处)设置select或list选择逻辑  
	如`desktop/winMgr/__winMgr__.nix`
	```nix
	...
	let
		mkWmEnable = name: lib.mkDefault (builtins.elem name config.desktop.winMgr.list);
	in
	{
		# 定义list
		options.desktop.winMgr.list = ...
			# 实现list选择逻辑
			desktop.winMgr.niri.enable    = mkWmEnable "niri";
			desktop.winMgr.labwc.enable   = mkWmEnable "labwc";
			desktop.winMgr.hypr.enable    = mkWmEnable "hypr";
			desktop.winMgr.mangowc.enable = mkWmEnable "mangowc";
		...
	}
	```

4. **最小改动原则**: 每次增加功能只用简洁的语法造成最小的改动, 删除\简化则不受约束.比如能在变量里改动一处,就不要改动多处

5. **上层覆盖，不需反向**：上层可以覆盖下层引用的 NixOS option（例如 `services.xserver.xkb`），上层移除后下层降级到默认行为，不影响正常运行。

6. **模块路径与选项路径一致**：移动目录或重命名文件时，模块内 `cfg = config.<ns>.<name>` 的选项路径也必须同步更改。如 `desktop/shell/bar/xxx/` 移到 `desktop/shell/xxx/`，选项从 `config.desktop.bar.xxx` 改为 `config.desktop.shell.xxx`。

7. **`_` 前缀表示完整实现（全家桶）**：`_xxx/` 目录和父目录平级，选项路径也包含 `_`。


### 桌面组件

- 通过 `desktop.*.list` / `desktop.*.select` 选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.winMgr.list` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装
- `desktop/__desktop__.nix` 设有公共默认值，减少 lap/pc 之间的重复

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── lib/                # 工具库
│   ├── default.nix     # 聚合导出 (nixpkgsOverlays)
│   └── overlays.nix    # 三分支 nixpkgs overlay (stable/unstable/master)
├── host/               # 主机配置
│   ├── common.nix      # 共享配置聚合
│   ├── lap/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   ├── boot.nix
│   │   └── driver.nix        # 主机差异驱动
│   └── pc/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       ├── boot.nix
│       └── driver.nix
│
├── core/               # Layer 0: NixOS 内核
│   ├── __core__.nix    # enable 开关 + imports + 默认值
│   ├── console.nix     # 控制台 (TTY 字体/键盘)
│   ├── networking.nix  # 网络 (防火墙/NetworkManager)
│   ├── system.nix      # 时区/语言/nix 设置/sudo
│   └── user.nix        # 用户账户
│
├── modules/            # Layer 1: NixOS 模块扩展
│   ├── __modules__.nix     # enable 开关 + imports + lib.mkDefault 默认值
│   ├── lang/               # 语言工具链
│   │   ├── __lang__.nix    # languages option + imports
│   │   ├── c-cpp.nix
│   │   ├── go.nix
│   │   ├── java.nix
│   │   ├── javascript.nix
│   │   ├── python.nix
│   │   └── rust.nix
│   ├── services/           # 系统服务
│   │   ├── __services__.nix    # enable 开关 + imports
│   │   ├── audio.nix           # PipeWire (自声明 enable)
│   │   ├── kmscon.nix          # kmscon 虚拟终端
│   │   ├── ssh.nix             # SSH + GitHub 密钥
│   │   └── xserver.nix         # X11 xkb
│   ├── shells/             # Shell 配置
│   │   ├── __shells__.nix      # enable 开关 + imports + 默认 shell
│   │   ├── bash/
│   │   ├── fish/
│   │   └── zsh/
│   ├── virtual/            # 虚拟化/兼容运行时
│   │   ├── __virtual__.nix     # enable 开关 + imports
│   │   ├── nix-ld.nix          # 非 Nix 二进制兼容 (FHS)
│   │   ├── container.nix       # podman + distrobox
│   │   ├── appimage.nix        # flatpak + appimage binfmt
│   │   ├── waydroid.nix        # Android 容器
│   │   └── kvm.nix             # libvirtd + qemu
│   └── utilities/          # 系统工具
│       ├── __utilities__.nix   # enable 开关 + imports
│       ├── neovim/
│       ├── yazi/
│       └── basic-tools.nix
│
├── desktop/            # Layer 2: 桌面环境
│   ├── __desktop__.nix     # enable 开关 + imports + lib.mkDefault 默认值
│   ├── base/               # 基础配置 (GTK/Qt/光标/字体/Stylix)
│   │   └── __base__.nix
│   ├── dispMgr/            # sddm / greetd / noctalia-greeter
│   │   └── __dispMgr__.nix
│   ├── winMgr/             # niri / hypr / labwc / mangowc
│   │   └── __winMgr__.nix
│   ├── shell/              # 桌面外壳层 (bar/launcher/lock/notif/pwmenu/wall)
│   │   ├── __shell__.nix
│   │   ├── bar/            # waybar / ironbar
│   │   ├── _noctalia/      # 完整 shell（替换 shell/ 下全部碎片） (bar+launcher+wallpaper 一体)
│   │   ├── launcher/       # wofi / rofi / fuzzel
│   │   ├── lock/           # swaylock
│   │   ├── notif/          # swaync / mako
│   │   ├── pwmenu/         # wlogout
│   │   └── wall/           # waypaper / awww
│   ├── input/              # fcitx5 / rime / ibus
│   │   └── __input__.nix
│   ├── term/               # kitty
│   │   └── __term__.nix
│   ├── fileMgr/            # dolphin / thunar
│   │   └── __fileMgr__.nix
│   └── browser/            # firefox
│       └── __browser__.nix
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
│   │   ├── __toolkits__.nix    # enable 开关 + imports
│   │   ├── misc.nix           # 杂项工具
│   │   ├── vm-managers.nix    # 虚拟机管理
│   │   └── wireshark.nix      # 网络分析
│   ├── game/           # 游戏
│   │   ├── __game__.nix      # enable 开关 + imports
│   │   └── steam.nix         # Steam (自声明 enable)
│   └── containers/     # 容器化应用
│       ├── __containers__.nix    # enable 开关 + imports
│       ├── debian/
│       └── kali/
│
└── secrets/            # SOPS 加密密钥 (__secrets__.nix)
```