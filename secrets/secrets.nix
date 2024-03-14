let
  leonardo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWxS8tdN3j7Vm337RmJTzYTMbkAZN5g610ZesH4vhd8";
  hanekawa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOafACtb4IgSczDrollTm/t/xIYcVdLlUxDz72TxsZJZ";
  kunagisa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrMCLu3VvQVmd2cqreAJsVKkrtKXqgzO8i8NDm06ysm";
  keys = [ leonardo hanekawa kunagisa ];
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
}
