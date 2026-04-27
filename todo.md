# nixcfg 5年架构优化 — 待办清单

> 当前项目路径: `/home/e/nixcfg`
> 两台机器: lap (笔记本) / pc (台式机)
> 每项改动前需要你的确认 — 在此文件逐条标注 `✓ 同意 / ✗ 放弃 / → 修改为...`

---

## P0 — 基础设施（立即做，长期收益大）

### P0-1. 添加 `lib/` 目录 ✓ 已完成

提取可复用的 Nix 函数，避免 flake.nix 膨胀。

```
lib/
├── default.nix          ← 聚合导出
├── overlays.nix         ← 3路 overlay (stable/unstable/master) 工厂函数
└── validators.nix       ← mkOption 类型校验辅助
```

### P0-2. 添加 `checks` — flake 静态检查 ✓ 已完成

```nix
checks.x86_64-linux = {
  formatting = nixpkgs-fmt --check   # 代码风格
  dead-code = deadnix                # 死代码检测
  statix = statix check              # lint
};
```

`nix flake check` 一键验证。

### P0-3. 添加 `devShells` + `.envrc` ✓ 已完成 (b930157)

devShells.default 已有 nixpkgs-fmt deadnix statix sops age + 新加 nixd。`.envrc` 已创建。

### P0-4. options 类型强化 + enable 开关 ✓ 已完成 (已提前实装)

- desktop enable 开关 → desktop/options.nix:3
- development.languages → `listOf (enum [...])` → __development__.nix:3
- 所有选项 nullOr + enum → desktop/options.nix 全部
- 模块层 enable 开关 → __modules__.nix (services/dev/shells/virt/utils)
- 零 `listOf str` 残留

---

## P1 — 架构强化（1-2 周内做）

### P1-1. `special-opt.nix` 填坑 ✓ 已完成 (7310f73)

各层公共配置用 `lib.mkDefault`，host 在 `special-opt.nix` 中覆写。

### P1-2. secrets 运行时检测 ✗ 放弃

构建时沙箱中 pathExists 永远 false，不接受 impure。

### P1-3. nginx basicAuth 密码进 SOPS ✓ 已完成 (2be58e8)

密码 hash 存入 `secrets/token.yaml`，用 sops template 注入 nginx 配置。

### P1-4. `overlays` 从 flake.nix 剥离到 `lib/overlays.nix` ✓ 已完成

---

## P2 — 长期维护（有需要时做）

### P2-1. `hardware-configuration.nix` → `disko` ✓ 已完成 (69f9a10)

### P2-2. overlays 懒求值优化 ✓ 已完成 (69f9a10)

已在 overlays.nix 中注释保留 lazy 模式，当前用 eager。

### P2-3. 模块 enable 开关扩展 ✓ 已完成 (69f9a10)

### P2-4. README + ARCHITECTURE.md ✓ 已完成 (a4a7837)

### P2-5. pre-commit hooks

`.pre-commit-config.yaml` — commit 前自动跑 `nixpkgs-fmt` + `statix`。

→ 建分支: `feat/p2-5-pre-commit`

---

## 额外发现（不属于架构但值得看）

### B1. host 之间 `boot.nix` 有重复 → 先不改

### B2. `networking.hostName = "nixos"` 硬编码 → 先不改

### B3. `extraGroups` 分散在多处 → 去中心化设计，不改

---

## 进度总览

| 状态 | 数量 | 项目 |
|------|------|------|
| ✓ 已完成 | 12 | P0-1~P0-4, P1-1, P1-3, P1-4, P2-1~P2-4 |
| → 待做 | 1 | P2-5 |
| ✗ 放弃 | 1 | P1-2 |
