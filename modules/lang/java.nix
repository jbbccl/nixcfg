{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "java" config.modules.lang.list) {
  # 回退到经典 JDK: Java 8 + 自带 JavaFX(Zulu FX)。
  # 之前的 JBR 没有 JavaFX, 跑 JavaFX 应用会 NoClassDefFoundError: javafx/application/Application;
  # 普通 OpenJDK(含 pkgs.jdk)同样不带 JavaFX, 所以这里用 zulu8 的 FX 构建。
  home-manager.users.${username}.home.packages = with pkgs; [
    (zulu8.override {enableJavaFX = true;})
  ];
}
