let
	Key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC0ZPLauThOVJOyxXmysOPYILhpLpxcfu7HpTh//fnbs e@nixos";
in
{
	"airport_1.age".publicKeys = [ Key ];
	"airport_2.age".publicKeys = [ Key ];
}

# ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
# agenix -e airport_2.age