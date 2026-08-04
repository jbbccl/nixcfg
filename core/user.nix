{username, ...}: {
  users.users.${username} = {
    uid = 1000;
    isNormalUser = true;
    ignoreShellProgramCheck = true;
    extraGroups = ["wheel" "video" "audio" "render"];
    linger = true;
  };
}
