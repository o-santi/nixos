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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, deploy-rs, nix-darwin, ... } @ inputs : let
    inherit (builtins) readDir attrNames listToAttrs split head;
    for-all-systems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "arrch64-linux"
        "aarch64-darwin"
      ] (system: f (import nixpkgs {
        overlays = [ inputs.emacs-overlay.overlays.default ];
        inherit system;
      }));
    mods = map (p: ./modules/${p}) (attrNames (readDir ./modules));
    make-config-named = host: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${host}.nix
        inputs.home-manager.nixosModules.default
      ] ++ mods;
    };
    get-basename = n: head (split "\\." n);
    hosts-names = map get-basename (attrNames (readDir ./hosts));
    nixos-configs = map (h: { name= h; value = make-config-named h;}) hosts-names;
  in rec {
    nixosConfigurations = listToAttrs nixos-configs;
    packages = for-all-systems (pkgs: {
      emacs = pkgs.callPackage ./modules/emacs/package.nix {};
    });
    deploy.nodes.iori = {
      hostname = "ssh.santi.net.br";
      remoteBuild = true;
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.aarch64-linux.activate.nixos nixosConfigurations.iori;
      };
    };
    darwinConfigurations.nami = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        inputs.home-manager.darwinModules.home-manager
        ./hosts/nami.nix
      ] ++ mods;
    };
  };
}
