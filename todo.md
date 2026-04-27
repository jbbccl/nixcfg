# nixcfg 5年架构优化 — 待办清单 ✓ ALL DONE

> 项目路径: `/home/e/nixcfg` / 机器: lap + pc
> 全部 14 项: 13 ✓ 已完成 / 1 ✗ 放弃

---

## P0 — 基础设施

| 项目 | 状态 |
|------|------|
| P0-1 lib/ 目录 | ✓ |
| P0-2 flake checks | ✓ |
| P0-3 devShells + .envrc | ✓ (b930157) |
| P0-4 options 类型强化 | ✓ |

## P1 — 架构强化

| 项目 | 状态 |
|------|------|
| P1-1 special-opt.nix | ✓ (7310f73) |
| P1-2 secrets 运行时检测 | ✗ 放弃 (impure) |
| P1-3 nginx SOPS | ✓ (2be58e8) |
| P1-4 overlays 剥离 | ✓ |

## P2 — 长期维护

| 项目 | 状态 |
|------|------|
| P2-1 disko | ✓ (69f9a10) |
| P2-2 lazy overlay | ✓ (69f9a10) |
| P2-3 模块 enable 开关 | ✓ (69f9a10) |
| P2-4 README | ✓ (a4a7837) |
| P2-5 pre-commit hooks | ✓ (3c46c49) |

## 额外发现

| 项目 | 状态 |
|------|------|
| B1 boot.nix 重复 | → 先不改 |
| B2 hostName 硬编码 | → 先不改 |
| B3 extraGroups 分散 | → 去中心化设计 |

## 分支映射

| 分支 | 内容 |
|------|------|
| give_you | 主分支 (todo 对账 + README 更新) |
| feat/p0-3-envrc | .envrc + nixd → b930157 |
| feat/p0-4-type-safety | 验证通过，无代码改动 → 80c134e |
| feat/p2-5-pre-commit | .pre-commit-config.yaml → 3c46c49 |
