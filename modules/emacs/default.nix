{ pkgs, inputs, lib, config,  ...}:
let
  outside-emacs = with pkgs; [
    nil
    ripgrep
    emacs-lsp-booster
    delta
  ];
  org-tangle-elisp-blocks = (pkgs.callPackage ./org.nix {inherit pkgs; inherit (inputs) from-elisp;}).org-tangle ({ language, flags } : let
    is-elisp = (language == "emacs-lisp") || (language == "elisp");
    is-tangle = if flags ? ":tangle" then
      flags.":tangle" == "yes" || flags.":tangle" == "y" else false;
  in
    is-elisp && is-tangle
  );
  config-el = pkgs.writeText "config.el" (org-tangle-elisp-blocks (builtins.readFile ./README.org));
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs.override {
      withGTK3 = true;
      withNativeCompilation = true;
      withAlsaLib = true;
      withSystemd = true;
      withToolkitScrollBars = true;
      withImageMagick = true;
    };
    override = epkgs: epkgs // {
      eglot-booster = pkgs.callPackage ./eglot-booster.nix {
        inherit (pkgs) fetchFromGitHub;
        inherit (epkgs) trivialBuild;
      };
    };
    config = config-el; 
    alwaysEnsure = true;
    defaultInitFile = true;
    extraEmacsPackages = epkgs: with epkgs; [
      (treesit-grammars.with-grammars (g: with g; [
        tree-sitter-rust
        tree-sitter-python
      ]))
    ] ++ outside-emacs;
  };
in with lib; {
  options.santi-modules.emacs.enable = mkEnableOption "Enable emacs configuration";
  config = mkIf config.santi-modules.emacs.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      emacs
    ] ++ outside-emacs;
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = ["Iosevka"]; })
    ];
  };
}

