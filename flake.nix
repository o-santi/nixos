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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... } @ inputs :
    let
      system = "x86_64-linux";
      hosts = [
        "hanekawa" # notebook
        "kunagisa" # workstation
      ];
      defaultNixosSystem = host: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/${host}/configuration.nix
          ./users/leonardo.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs 
        (map (host: {name = host; value = defaultNixosSystem host; }) hosts)
      ;
    };
}
