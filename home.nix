{ config, pkgs, inputs, ... } :
{
  home = {
    username = "leonardo";
    homeDirectory = "/home/leonardo";
    stateVersion = "23.05";
    sessionVariables.GTK_THEME = "Adwaita-dark";
    packages = with pkgs; [
      discord
      inputs.emacs.packages.x86_64-linux.default
      slack
      fzf
      whatsapp-for-linux
    ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "git"
        "fzf"
        "rust"
      ];
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      enable_audio_bell = false;
      background_opacity = "0.7";
    };
  };

  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    extraConfig = {
      user.name = "Leonardo Santiago";
      user.email = "leonardo@mixrank.com";
      color.ui = true;
    };
  };
}
