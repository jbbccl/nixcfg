{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.apps.toolkits.hive;

  # 官方二进制发行版(不含 Hadoop), 复用 nixpkgs hadoop + JDK21(Hive 4.2.x 编译目标)
  hive = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "hive";
    version = "4.2.1";

    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/hive/hive-${finalAttrs.version}/apache-hive-${finalAttrs.version}-bin.tar.gz";
      hash = "sha256-Ulwti4uii4CN82GoJ30q9lWiV9Bj6iyXmXkACbhDokU=";
    };

    nativeBuildInputs = [pkgs.makeWrapper];
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      mv * $out/
      runHook postInstall
    '';

    # 所有入口(beeline/schematool/hiveserver2...)最终都 source bin/hive, 只包一个即可。
    # conf/data/state 默认走 XDG 目录, 且均可用环境变量覆盖。
    postFixup = ''
      wrapProgram $out/bin/hive \
        --set-default JAVA_HOME ${pkgs.jdk21_headless.home} \
        --set-default HADOOP_HOME ${pkgs.hadoop} \
        --run 'export HIVE_CONF_DIR="''${HIVE_CONF_DIR:-$HOME/.config/hive}"' \
        --run 'mkdir -p "$HIVE_CONF_DIR" "$HOME/.local/share/hive" "$HOME/.local/state/hive"' \
        --run 'export HADOOP_CLIENT_OPTS="''${HADOOP_CLIENT_OPTS:-} -Dderby.stream.error.file=$HOME/.local/state/hive/derby.log"' \
        --prefix PATH : ${lib.makeBinPath [pkgs.jdk21_headless pkgs.hadoop]}
    '';

    meta = {
      description = "Apache Hive data warehouse software";
      homepage = "https://hive.apache.org/";
      license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [binaryBytecode];
      mainProgram = "hive";
      platforms = ["x86_64-linux"];
    };
  });
in {
  options.apps.toolkits.hive.enable = lib.mkEnableOption "Apache Hive 4.2.1 (data warehouse, local Derby metastore)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [hive];

    # hive-site.xml 基本不变, 交给 home-manager 声明; 数据/日志仍在 $HOME 下由运行时创建
    home-manager.users.${username} = {config, ...}: {
      xdg.configFile."hive/hive-site.xml".text = ''
        <configuration>
          <property>
            <name>hive.metastore.warehouse.dir</name>
            <value>file://${config.home.homeDirectory}/.local/share/hive/warehouse</value>
          </property>
          <property>
            <name>javax.jdo.option.ConnectionURL</name>
            <value>jdbc:derby:;databaseName=${config.home.homeDirectory}/.local/share/hive/metastore_db;create=true</value>
          </property>
          <property>
            <name>hive.execution.engine</name>
            <value>mr</value>
          </property>
        </configuration>
      '';
    };
  };
}
