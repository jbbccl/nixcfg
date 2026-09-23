{
  config,
  pkgs,
  lib,
  username,
  ...
}:
lib.mkIf (builtins.elem "java" config.modules.lang.list) {
  # JBR 是唯一带 Wayland 后端的 JDK, 但它不会自动选用, 需显式指定;
  # 该属性对非 JBR 的 JDK 无害(忽略后回退 X11), 所以放全局 session 变量
  environment.sessionVariables = {
    JAVA_HOME = "${pkgs.jetbrains.jdk-no-jcef.home}";
    JDK_JAVA_OPTIONS = "-Dawt.toolkit.name=WLToolkit";
  };

  home-manager.users.${username}.home.packages = with pkgs; [
    jetbrains.jdk-no-jcef
  ];
}
