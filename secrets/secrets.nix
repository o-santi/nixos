let
  kunagisa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWxS8tdN3j7Vm337RmJTzYTMbkAZN5g610ZesH4vhd8";
  kunagisa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDrMCLu3VvQVmd2cqreAJsVKkrtKXqgzO8i8NDm06ysm";
  hanekawa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOafACtb4IgSczDrollTm/t/xIYcVdLlUxDz72TxsZJZ";
  hanekawa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuIjOE3xi/frXJHXQuIBntuXP8XyboCWRx48o3sYeub";
  larissa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFQN59YDFwwQt/1rb1dHZnxsNV2geWUvHyTKqjdSA52";
  larissa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKjyS7vbCxr7oDqBpnhHQQzolAW6Fqt1FTOo+hT+lSC";
  keys = [ kunagisa-user hanekawa-user kunagisa hanekawa larissa larissa-user];
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "user-pass.age".publicKeys = keys;
}
