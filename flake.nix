{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs = {
      url = "github:o-santi/emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs, ... } @ inputs :
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
          # ./exwm.nix
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations = builtins.listToAttrs 
        (map (host: {name = host; value = defaultNixosSystem host; }) hosts)
      ;
    };
}
