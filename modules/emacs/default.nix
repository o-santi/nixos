{ pkgs, inputs, lib, config,  ...}:
let
  outside-emacs = with pkgs; [
    git
    nil
    ripgrep
    emacs-lsp-booster
    delta
  ];
  emacs = pkgs.emacsWithPackagesFromUsePackage {
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
    };
    config = ./README.org;
    alwaysTangle = true;
    defaultInitFile = true;
    extraEmacsPackages = epkgs: [
      (epkgs.treesit-grammars.with-grammars (g: with g; [
        tree-sitter-rust
        tree-sitter-python
      ]))
    ];
  };
in with lib; {
  options.santi-modules.emacs.enable = mkEnableOption "Enable emacs configuration";
  config = mkIf config.santi-modules.emacs.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      emacs
    ] ++ outside-emacs;
    fonts.packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
    ];
  };
}

