# 项目规范

**项目基础架构，和项目结构同步更改**

## 项目结构树

```
nixcfg/
├── flake.nix           # 入口
├── flake.lock
├── .sops.yaml
├── host/               # 主机配置 (二级)
│   ├── common.nix      # 共享配置聚合
│   ├── lap/
│   └── pc/
├── modules/            # 功能模块
│   ├── AI/              # AI 服务
│   │   └── litellm/
│   ├── development/     # 开发环境
│   │   └── flake-c-py/
│   ├── services/        # 系统服务
│   │   ├── proxy/
│   │   └── stream/
│   ├── shells/          # Shell 配置
│   │   ├── fish/
│   │   └── zsh/
│   ├── utilities/       # 工具
│   │   ├── neovim/
│   │   ├── pdf.nix
│   │   └── yazi/
│   └── virtual/         # 虚拟化
│       ├── container.nix
│       └── hardware/    # 硬件虚拟化
│           └── kvm.nix
├── desktopEnv/         # 桌面环境
│   ├── deSession/       # 桌面会话
│   │   ├── plasma/
│   │   └── xfce/
│   ├── displayMgr/      # 显示管理器
│   │   ├── greetd/
│   │   └── sddm/
│   ├── winMgr/          # 窗口管理器
│   │   ├── hypr/
│   │   ├── labwc/
│   │   ├── mangowc/
│   │   └── niri/
│   └── wmAddons/        # 窗口管理器插件
│       ├── fileMgr/
│       ├── inputMth/
│       ├── pty/
│       ├── wallpaper/
│       └── statusBar/  # 状态栏
│           └── barAddons/
│               ├── launcher/   # fuzzel/rofi/wofi
│               ├── lock/      # swaylock/wlogout
│               ├── notice/    # mako/swaync
│               ├── noctalia/
│               └── waybar/
├── guiToolkit/         # GUI 工具
├── setting/            # 系统设置
├── secrets/            # 密钥
└── static/             # 静态资源
    └── wallpaper/
```

## 规范

1. 本项目是以 flake.nix 为根节点，大体自底层向上生长的树。
2. 每个节点是配置某一个软件或功能的文件或文件夹。
3. 非根节点通过 import 或其他引用方式连接子节点，每个非根节点提供一个文件供上级引用。
4. 除二级 host 目录外，任意节点移除不会对系统正常运行造成影响。
5. 若 b 功能或软件的运行依赖 a 功能或软件，则 b 位于 a 的子树，或兄弟。
6. 继续上一条，若 b 位于 a 的子树导致树过于失衡，则将 b 移动到 a 的兄弟节点，并且 b 命名上体现对 a 的依赖。父节点将 a，b 视为同一节点，同步添加或移除。
7. 任意节点所需依赖及其配置文件，在节点内部完成。
8. 任意节点移除，不会对上层节点，或同级无关节点造成影响。
9. 任意节点移除，不会留下残余配置或依赖。
