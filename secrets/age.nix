{ agenix, ... }:
{
   environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
   age.identityPaths = [ "/home/e/.ssh/id_ed25519" ];
   age.secrets.airport_1.file = ./airport_1.age;
   age.secrets.airport_2.file = ./airport_2.age;
}
