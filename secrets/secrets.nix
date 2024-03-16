let
  kunagisa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWxS8tdN3j7Vm337RmJTzYTMbkAZN5g610ZesH4vhd8";
  kunagisa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrMCLu3VvQVmd2cqreAJsVKkrtKXqgzO8i8NDm06ysm";
  hanekawa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOafACtb4IgSczDrollTm/t/xIYcVdLlUxDz72TxsZJZ";
  hanekawa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuIjOE3xi/frXJHXQuIBntuXP8XyboCWRx48o3sYeub";
  keys = [ kunagisa-user hanekawa-user kunagisa hanekawa];
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
}
