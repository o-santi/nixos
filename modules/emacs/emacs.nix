{ pkgs, inputs, ...}:
let
  outside-emacs = with pkgs; [
    (python3.withPackages (p: (with p; [
      python-lsp-server
      python-lsp-ruff
      pylsp-mypy
    ])))
    nil
    rust-analyzer
    parallel
  ];
  org-tangle-elisp-blocks = (pkgs.callPackage ./org.nix {inherit pkgs; from-elisp = inputs.from-elisp;}).org-tangle ({ language, flags } :
    let is-elisp = (language == "emacs-lisp") || (language == "elisp");
        is-tangle = if flags ? ":tangle" then
          flags.":tangle" == "yes" || flags.":tangle" == "y" else false;
    in is-elisp && is-tangle
  );
  config-el = pkgs.writeText "config.el" (org-tangle-elisp-blocks (builtins.readFile ./README.org));
  emacs = (pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs.override {
      withGTK3 = true;
      withNativeCompilation = true;
      withAlsaLib = true;
      withSystemd = true;
      withToolkitScrollBars = true;
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
    override = final: prev: {
      final.buildInputs = prev.buildInputs or [] ++ outside-emacs;
    };
  });
in
{
  config = {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlays.default ];
    environment.systemPackages = [
      emacs
    ] ++ outside-emacs;
    fonts.packages = with pkgs; [
      emacs-all-the-icons-fonts
      (nerdfonts.override { fonts = ["Iosevka"]; })
    ];
  };
}

