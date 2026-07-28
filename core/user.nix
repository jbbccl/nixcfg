{username, ...}: {
  users.users.${username} = {
    uid = 1000;
    isNormalUser = true;
    ignoreShellProgramCheck = true;
    extraGroups = ["wheel" "video" "audio" "render"];
    # packages = with pkgs; [tree];
    linger = true;
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "lccbbj";
        email = "lccbbj@example.com";
      };
      init.defaultBranch = "main";
    };
  };
}
