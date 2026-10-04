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

8. **username 是有优先级的全局变量**：`core/user.nix` 声明 `core.user.username`（`default = "e"`，最低优先级），并桥接进 `_module.args`，所有模块头 `{ username, ... }` 保持零改动。主机覆盖：`configuration.nix` 里写 `core.user.username = "foo";`（普通赋值即可，`mkForce` 兜底）。`specialArgs` 不传 username，避免与 `_module.args` 的优先级纠缠。新增主机：复制 `host/lap` 为 `host/xx`，在 `nixosConfigurations` 登记一行，其余改动全部留在 `host/xx/` 内。


### 桌面组件

- 通过 `desktop.*.list` / `desktop.*.select` 选项进行开关，各模块内部使用 `mkIf` 自激活
- `desktop.winMgr.list` 是列表类型：可同时启用多个 WM，登录界面切换，无需重构
- 各 WM 自带的 portal 依赖只在该 WM 启用时安装
- `desktop/__desktop__.nix` 设有公共默认值，减少 lap/pc 之间的重复
- **「打开文件所在位置」不是 `xdg.portal` 管的**：浏览器（Chromium/Brave 的 `ShowItems`）走 D-Bus 名 `org.freedesktop.FileManager1`，`xdg.portal` 的 `xdgOpenUsePortal` 只影响 `xdg-open`/OpenURI 那条路。系统里 dolphin / thunar / nautilus 会同时注册该名字，dbus-broker 按 `$XDG_RUNTIME_DIR` → `$XDG_DATA_HOME` → `$XDG_DATA_DIRS` → 配置内 `<servicedir>` 的顺序取先扫到的那个（重名直接 `Ignoring duplicate name` 跳过）。因此 `desktop/fileMgr/thunar/thunar.nix` 在用户级 `~/.local/share/dbus-1/services` 放一份同名 service，启用 thunar 即稳定接管；目录的 `inode/directory` 关联也在同一处用 `xdg.mimeApps` 设到 `thunar.desktop`。

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── host/               # 主机配置
│   ├── common.nix      # 共享配置聚合
│   ├── lap/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   ├── boot.nix
│   │   └── driver.nix        # 主机差异驱动
│   ├── pc/
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   ├── boot.nix
│   │   └── driver.nix
│   └── install-iso/      # 安装镜像 (offline installer, 独立精选 imports)
│       └── configuration.nix  # 生成 /etc/nixos/INSTALL.txt
│
├── core/               # Layer 0: NixOS 内核
│   ├── __core__.nix    # imports
│   ├── console.nix     # 控制台 (TTY 字体/键盘)
│   ├── networking.nix  # 网络 (防火墙/NetworkManager)
│   ├── system.nix      # 时区/语言/nix 设置/sudo
│   └── user.nix        # 用户账户 (core.user.username → _module.args.username)
│
├── modules/            # Layer 1: NixOS 模块扩展
│   ├── __modules__.nix     # imports + lib.mkDefault 默认值
│   ├── lang/               # 语言工具链
│   │   ├── __lang__.nix    # modules.lang.list option + imports
│   │   ├── c-cpp.nix
│   │   ├── go.nix
│   │   ├── java.nix
│   │   ├── javascript.nix
│   │   ├── python.nix
│   │   └── rust.nix
│   ├── services/           # 系统服务
│   │   ├── __services__.nix    # imports
│   │   ├── audio.nix           # PipeWire (自声明 enable)
│   │   ├── kmscon.nix          # kmscon 虚拟终端
│   │   ├── ssh.nix             # SSH + GitHub 密钥
│   │   └── xkb.nix             # xkb 键盘布局 (us + caps:swapescape)
│   ├── shells/             # Shell 配置
│   │   ├── __shells__.nix      # enable 开关 + imports + 默认 shell
│   │   ├── bash/
│   │   ├── fish/
│   │   └── zsh/
│   ├── virtual/            # 虚拟化/兼容运行时
│   │   ├── __virtual__.nix     # imports
│   │   ├── nix-ld.nix          # 非 Nix 二进制兼容 (FHS)
│   │   ├── container.nix       # podman + distrobox
│   │   ├── appimage.nix        # flatpak + appimage binfmt
│   │   ├── waydroid.nix        # Android 容器
│   │   └── kvm.nix             # libvirtd + qemu
│
├── desktop/            # Layer 2: 桌面环境
│   ├── __desktop__.nix     # list/select 选项 + lib.mkDefault 默认值
│   ├── base/               # 基础外观 (GTK/Qt/光标/字体/Stylix)
│   │   ├── __base__.nix    # desktop.base.theme
│   │   ├── cursor.nix
│   │   ├── fonts.nix
│   │   ├── gtk.nix
│   │   ├── qt.nix
│   │   └── stylix.nix
│   ├── dispMgr/            # sddm / greetd / noctalia-greeter
│   │   ├── __dispMgr__.nix # desktop.dispMgr.select
│   │   ├── greetd/
│   │   ├── noctalia-greeter/
│   │   └── sddm/
│   ├── winMgr/             # niri / hypr / labwc / mangowc
│   │   ├── __winMgr__.nix  # desktop.winMgr.list
│   │   ├── base/           # 各 WM 共用
│   │   │   ├── __base__.nix
│   │   │   ├── polkit.nix
│   │   │   └── xdg.nix     # xdg.portal / xdg.mime / xdg.menus
│   │   ├── hypr/
│   │   ├── labwc/
│   │   ├── mangowc/
│   │   └── niri/
│   ├── shell/              # 桌面外壳层 (bar/launcher/lock/notif/pwmenu/wall)
│   │   ├── __shell__.nix
│   │   ├── bar/            # waybar (含 niri-taskbar) / ironbar
│   │   ├── _noctalia/      # 完整 shell（替换 shell/ 下全部碎片） (bar+launcher+wallpaper 一体)
│   │   ├── launcher/       # wofi / rofi / fuzzel
│   │   ├── lock/           # swaylock
│   │   ├── notif/          # swaync / mako
│   │   ├── pwmenu/         # wlogout
│   │   └── wall/           # waypaper / awww
│   ├── input/              # fcitx5 / rime / ibus
│   │   └── __input__.nix   # desktop.input.select
│   ├── term/               # kitty / alacritty
│   │   └── __term__.nix    # desktop.term.select
│   ├── fileMgr/            # dolphin / thunar
│   │   ├── __fileMgr__.nix # desktop.fileMgr.list
│   │   ├── dolphin/
│   │   └── thunar/         # 内含用户级 FileManager1 D-Bus 覆盖 + inode/directory 关联
│   ├── browser/            # firefox / brave
│   │   ├── __browser__.nix # desktop.browser.select
│   │   ├── brave.nix
│   │   ├── firefox.nix
│   │   ├── betterfox.user.js
│   │   └── smoothfox.user.js
│   └── editor/             # vscodium / zed
│       └── __editor__.nix  # desktop.editor.list
│
├── apps/               # Layer 3: 用户应用
│   ├── __apps__.nix    # imports + lib.mkDefault 默认值
│   ├── services/       # 后台守护进程
│   │   ├── __services__.nix    # imports
│   │   ├── ai/                 # hermes-agent + opencode + pi + grok + dsh (litellm 可选)
│   │   │   ├── __ai__.nix      # enable 开关 + sops 密钥 + 子模块默认值
│   │   │   ├── dsh/            # DeepSeek Harness
│   │   │   │   ├── dsh.nix         # enable 开关 + api-key 注入
│   │   │   │   └── dsh-package.nix # GitHub 源码 + pnpm 构建; 运行期固定官方 node 24.18.1
│   │   │   ├── grok/
│   │   │   ├── hermes/
│   │   │   ├── litellm/
│   │   │   ├── opencode/
│   │   │   └── pi/
│   │   ├── proxy/              # mihomo + dae/daed
│   │   │   ├── __proxy__.nix   # enable 开关 + imports
│   │   │   ├── mihomo/
│   │   │   └── dae/
│   │   ├── ingress/            # cloudflared + nginx
│   │   │   ├── __ingress__.nix # enable/domain/port 选项 + sops 密钥
│   │   │   ├── cloudflared.nix
│   │   │   └── nginx.nix
│   │   └── remote-ctrl/        # nginx + wayvnc
│   │       ├── __remote-ctrl__.nix  # enable 开关 + imports
│   │       ├── nginx.nix
│   │       └── vnc.nix
│   ├── toolkits/       # /opt/toolkit 工具集
│   │   ├── __toolkits__.nix    # imports
│   │   ├── git.nix             # git 身份/配置
│   │   ├── neovim.nix          # nixvim 编辑器 (EDITOR/VISUAL)
│   │   ├── yazi/               # 终端文件管理
│   │   │   └── yazi.nix
│   │   ├── misc.nix            # 杂项工具
│   │   ├── typst.nix           # Typst 工具链 (typst/tinymist)
│   │   ├── latex.nix           # LaTeX 工具链 (tectonic)
│   │   ├── vm-managers.nix     # 虚拟机管理
│   │   ├── mcu.nix             # 单片机工具链
│   │   ├── fpga.nix            # FPGA 工具链
│   │   └── rs.nix              # 逆向/底层工具链
│   ├── pentest/        # 渗透测试工具
│   │   ├── __pentest__.nix     # imports
│   │   ├── misc.nix            # 网络/逆向/移动安全工具
│   │   ├── c2.nix              # Sliver C2
│   │   ├── pwndbg.nix          # gdb 调试插件
│   │   ├── wireshark.nix       # 网络分析
│   │   ├── yakit.nix           # Yakit (Wayland)
│   │   ├── amass-package.nix     # 本地改写: amass
│   │   ├── dirsearch-package.nix # 本地改写: dirsearch
│   │   ├── sliver-package.nix    # 本地改写: sliver
│   │   └── yakit-package.nix     # 本地改写: yakit
│   └── game/           # 游戏
│       ├── __game__.nix      # imports
│       ├── steam.nix         # Steam (自声明 enable)
│       ├── wine.nix          # wine (wayland) + winetricks + umu
│       ├── linuwowo.nix      # LinUwUx Denuvo 运行时
│       │                     # (patched GE-Proton + cpuid_fault_emulation, AMD only)
│       ├── linuwowo.json
│       └── misc.nix
│
└── secrets/            # SOPS 加密密钥
    ├── __secrets__.nix
    ├── api_keys.yaml
    ├── ssh_keys.yaml
    └── token.yaml
```
