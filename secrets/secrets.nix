let
  inherit (builtins) attrValues concatLists;
  keys = concatLists (map attrValues (attrValues (import ./pub-ssh-keys.nix)));
in
{
  "personal-mail.age".publicKeys = keys;
  "work-mail.age".publicKeys = keys;
  "university-mail.age".publicKeys = keys;
  "authinfo.age".publicKeys = keys;
  "user-pass.age".publicKeys = keys;
}
