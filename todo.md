# nixcfg 5年架构优化 — 待办清单

> 当前项目路径: `/home/e/nixcfg`
> 两台机器: lap (笔记本) / pc (台式机)
> 每项改动前需要你的确认 — 在此文件逐条标注 `✓ 同意 / ✗ 放弃 / → 修改为...`

---

## P0 — 基础设施（立即做，长期收益大）

### P0-1. 添加 `lib/` 目录

提取可复用的 Nix 函数，避免 flake.nix 膨胀。

```
lib/
├── default.nix          ← 聚合导出
├── overlays.nix         ← 3路 overlay (stable/unstable/master) 工厂函数
├── mkHost.nix           ← 增强版 mkSystem
└── validators.nix       ← mkOption 类型校验辅助
```

### P0-2. 添加 `checks` — flake 静态检查

```nix
checks.x86_64-linux = {
  formatting = nixpkgs-fmt --check   # 代码风格
  dead-code = deadnix                # 死代码检测
  statix = statix check              # lint
};
```

`nix flake check` 一键验证。

### P0-3. 添加 `devShells` + `.envrc`

锁定开发工具版本，clone 即用。

```
devShells.default = pkgs.mkShell {
  buildInputs = [ nixpkgs-fmt statix deadnix sops age nixd ];
};
.envrc: use flake
```

### P0-4. options 类型强化 + enable 开关

- `desktop` 加 `enable` 开关（允许整体禁用桌面层）
- `development.languages` 从 `listOf str` 改为 `listOf (enum [...])` — 拼写错误编译期捕获
- 所有枚举型 options 改为 `nullOr`，未选时值为 null 而非空 list

---

## P1 — 架构强化（1-2 周内做）

### P1-1. `special-opt.nix` 填坑

目前两个 host 的 `special-opt.nix` 都是空文件 `{}`。

方案：各层公共配置用 `lib.mkDefault`，host 在 `special-opt.nix` 中覆写。

```
# desktop/base/theme.nix
fontSize = lib.mkDefault 11;

# host/pc/special-opt.nix
desktop.base.fontSize = 14;
```

同意

### P1-2. secrets 运行时检测

`secrets/__secrets__.nix` 第 4 行 `hasKey = true` 硬编码。

改为: `hasKey = builtins.pathExists ageKeyFile;`

难说, 构建时在沙箱中, 这么改永远为false, 我不接受 impure

### P1-3. nginx basicAuth 密码进 SOPS

`apps/services/remote-ctrl/nginx.nix:8` 密码 hash 明文硬编码。

方案：密码 hash 存入 `secrets/token.yaml`，用 sops template 注入 nginx 配置。

同意

### P1-4. `overlays` 从 flake.nix 剥离到 `lib/overlays.nix`

flake.nix 里 47-62 行的 sharedOverlays 块移到 lib/，flake.nix 只引用。以后加 overlay 不改 flake.nix。

同意

---

## P2 — 长期维护（有需要时做）

### P2-1. `hardware-configuration.nix` → `disko`

声明式磁盘分区，不再依赖 `nixos-generate-config`。换盘/重分区只需改 Nix 文件。

同意

### P2-2. overlays 懒求值优化

目前 `sharedOverlays` 在 import nixpkgs 时立即 eval 三份完整 nixpkgs。如果包数增长，eval 会变重。可以用 `callPackage` 模式延迟求值，或改用 `nixpkgs.legacyPackages` 共享单个实例。

ok

### P2-3. 模块 enable 开关扩展

目前只有 desktop 层有 `options.nix`。模块层（services/dev/virt）缺少 enable 开关，无法按需禁用整个模块组。

ok

### P2-4. README + ARCHITECTURE.md

项目文档。描述分层逻辑、模块约定、overlay 用法、如何加新 host。

ok

### P2-5. pre-commit hooks

`.pre-commit-config.yaml` — commit 前自动跑 `nixpkgs-fmt` + `statix`。避免提交格式错误的代码。

ok

---

## 额外发现（不属于架构但值得看）

### B1. host 之间 `boot.nix` 有重复

`kernelPackages`、`supportedFilesystems`、`perf_event_paranoid` 在两台机器都写了。可以抽到 `common.nix` 或单独的 `kernel.nix`。

为机器之间可能的差异准备的, 先不改

### B2. `networking.hostName = "nixos"` — 硬编码

`modules/services/networking.nix:3` 写死 hostName。可以改为从 `specialArgs.hostName` 读取，让 lap 和 pc 分别显示自己的名字。
暂时统一设备的host name,有需求再改

### B3. `core/user.nix` 的 `extraGroups` 和 `modules/services/networking.nix` 的 `extraGroups` 分开写

同一用户的 `extraGroups` 分散在多处，未来排查权限问题会很困难。建议聚合到 `core/user.nix`。

主要是去中心化, 这样注释某个模块的引用就自动离开该组

---
