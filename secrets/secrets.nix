let
  kunagisa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINWxS8tdN3j7Vm337RmJTzYTMbkAZN5g610ZesH4vhd8";
  hanekawa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOafACtb4IgSczDrollTm/t/xIYcVdLlUxDz72TxsZJZ";
  larissa-user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFQN59YDFwwQt/1rb1dHZnxsNV2geWUvHyTKqjdSA52";
  hosts-keys = builtins.attrValues (import ./hosts-pub-keys.nix);
  keys = [ kunagisa-user hanekawa-user larissa-user] ++ hosts-keys;
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "user-pass.age".publicKeys = keys;
}
