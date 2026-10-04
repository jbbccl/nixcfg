{lib, ...}: {
  imports = [
    ./lang/__lang__.nix
    ./services/__services__.nix
    ./shells/__shells__.nix
    ./virtual/__virtual__.nix
  ];

  config.modules = lib.mkDefault {
    lang.list = ["c-cpp" "javascript" "python" "rust" "go" "java"];
    services.audio.enable = true;
    services.audio.bluetooth = true;
    services.ssh.enable = true;
    services.xkb.enable = true;
    services.kmscon.enable = true;
    shells.enable = true;
    shells.fish.enable = true;
    shells.zsh.enable = true;
    virtual.nix-ld.enable = true;
    virtual.container.enable = true;
    virtual.waydroid.enable = true;
    virtual.appimage.enable = true;
    virtual.kvm.enable = true;
  };
}
