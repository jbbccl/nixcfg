{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.toolkits.fpga;
in {
  options.apps.toolkits.fpga.enable = lib.mkEnableOption "FPGA toolchains (iverilog, verilator, yosys, nextpnr)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # ── simulation ───────────────────────────────────
      iverilog # Icarus Verilog — 入门仿真
      verilator # Verilator — 工业级仿真/lint

      # ── synthesis / p&r ──────────────────────────────
      yosys # Yosys — RTL 综合
      nextpnr # nextpnr — 通用 place & route

      # ── testbench ────────────────────────────────────
      python3Packages.cocotb
    ];
  };
}
