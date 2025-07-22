{ pkgs }: let
  outside-emacs = with pkgs; [
    git
    nil
    ripgrep
    tinymist
    delta
    emacs-lsp-booster
  ];
in 
  pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable.override {
      withGTK3 = true;
      withNativeCompilation = true;
      withAlsaLib = true;
      withSystemd = true;
      withToolkitScrollBars = true;
      withImageMagick = true;
    };
    override = epkgs: let
      callPackage = pkgs.lib.callPackageWith (pkgs // epkgs);
    in epkgs // {
      eglot-booster = callPackage ./eglot-booster.nix {};
      eldoc-diffstat = callPackage ./eldoc-diffstat.nix {};
    };
    config = ./README.org;
    alwaysTangle = true;
    alwaysEnsure = true;
    defaultInitFile = true;
    extraEmacsPackages = epkgs: [
      (epkgs.treesit-grammars.with-grammars (g: with g; [
        tree-sitter-rust
        tree-sitter-python
        tree-sitter-nix
        tree-sitter-haskell
        tree-sitter-yaml
        tree-sitter-typst
      ]))
    ] ++ outside-emacs;
  }
