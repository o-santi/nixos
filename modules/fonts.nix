{ config, lib, pkgs, ...} : with lib; {
  options.santi-modules.font-config.enable = mkOption {
    type = types.bool;
    default = true;
    description = "Installs default fonts.";
  };
  config = mkIf config.santi-modules.font-config.enable {
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace =  [ "Iosevka" "IPAGothic" ];
          serif = [ "DejaVu Serif" "IPAPMincho" ];
        };
      };
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Iosevka" "FiraCode" ]; })
        ipafont
        kochi-substitute
        dejavu_fonts
      ];
    };
  };
}
