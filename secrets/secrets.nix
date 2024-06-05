let
  inherit (builtins) attrValues readFile;
  user-key = readFile ./user-ssh-key.pub;
  keys = [ user-key ] ++ (attrValues (import ./pub-ssh-keys.nix));
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "user-pass.age".publicKeys = keys;
}
