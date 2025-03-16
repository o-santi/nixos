{
  description = "My personal devices' flake modules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager.url = "github:nix-community/home-manager";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    mixrank.url = "git+ssh://git@gitlab.com/mixrank/mixrank";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... } @ inputs : let
    inherit (builtins) readDir attrNames listToAttrs split head;
    modules = map (p: ./modules/${p}) (attrNames (readDir ./modules));
    make-config-named = host: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${host}.nix
        inputs.home-manager.nixosModules.default
      ] ++ modules;
    };
    get-basename = n: head (split "\\." n);
    hosts-names = map get-basename (attrNames (readDir ./hosts));
    nixos-configs = map (h: { name= h; value = make-config-named h;}) hosts-names;
  in rec {
    nixosConfigurations = listToAttrs nixos-configs;
    deploy.nodes.iori = {
      hostname = "ssh.santi.net.br";
      remoteBuild = true;
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.aarch64-linux.activate.nixos nixosConfigurations.iori;
      };
    };
  };
}
