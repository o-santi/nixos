let
  inherit (builtins) attrValues readFile;
  user-key = readFile ./user-ssh-key.pub;
  keys = [ user-key ] ++ (attrValues (import ./host-pub-keys.nix));
in
{
  "user-ssh-key.age".publicKeys = keys;
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "user-pass.age".publicKeys = keys;
}
