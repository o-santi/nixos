{ config, lib, pkgs, ...}: with lib; let
  cfg = config.santi-modules;
  inherit (builtins) readFile attrValues;
in {
  options.santi-modules = { 
    secrets.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables secrets management through agenix";
    };
  };
  config = mkIf config.santi-modules.secrets.enable {
    environment.systemPackages = with pkgs; [
      rage
    ];
    home-manager.sharedModules = [(home-args: {
      home.file.".ssh/id_ed25519.pub".source = ../secrets/user-ssh-key.pub;
    })];
    users.users.leonardo = {
      openssh.authorizedKeys.keys = [
        (readFile ../secrets/user-ssh-key.pub)
      ] ++ attrValues (import ../secrets/host-pub-keys.nix);
    } // (lib.optionalAttrs pkgs.stdenv.isLinux {
      hashedPasswordFile = config.age.secrets.user-pass.path;
    });
    age.secrets = let
      with-perms = name: {
        file = ../secrets/${name}.age;
        owner = "leonardo";
        group = "users";
      };
    in {
      user-pass = with-perms "user-pass";
      user-ssh-key = {
        file = ../secrets/user-ssh-key.age;
        path = "/home/leonardo/.ssh/id_ed25519";
        owner = "leonardo";
        group = "users";
      };
    } // (optionalAttrs cfg.mu.enable (let
      mails = ["work-mail" "personal-mail" "university-mail"];
      mail-cfg = map (n: {name = n; value = with-perms n;}) mails;
    in
      listToAttrs mail-cfg))
    // (optionalAttrs cfg.services.cloudflared.enable {
      cloudflare = with-perms "cloudflare";
      cloudflare-api-token = with-perms "cloudflare-api-token";
    }) // (optionalAttrs cfg.emacs.enable {
      authinfo = with-perms "authinfo";
    });
  };
}
