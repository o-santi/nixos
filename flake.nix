{
  description = "My personal devices' flake modules";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "s3://mr-nixcache-icenyeamyubu?profile=mixrank"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "mr-nixcache-icenyeamyubu:q2ulb+bD5NCbp9nvvHod39/1qNqnYX0ACb8eQckb7pI="
    ];
  };

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
    from-elisp = {
      url = "github:o-santi/from-elisp";
      flake = false;
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    mixrank.url = "path:///home/leonardo/mx/mixrank";
  };

  outputs = { self, nixpkgs, home-manager, agenix, mixrank, ... } @ inputs :
    let
      inherit (builtins) readDir attrNames listToAttrs split head;
      modules = map (p: import ./modules/${p}) (attrNames (readDir ./modules));
      make-config-named = host: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${host}.nix
        ] ++ modules;
      };
      get-basename = n: head (split "\\." n);
      hosts-names = map get-basename (attrNames (readDir ./hosts));
      nixos-configs = map (h: { name= h; value = make-config-named h;}) hosts-names;
    in {
      nixosConfigurations = listToAttrs nixos-configs;
    };
}
