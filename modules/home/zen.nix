{ config, lib, inputs, ...}: with lib; let
  cfg = config.santi-modules;
in {
  options.santi-modules.zen-browser = mkEnableOption "Enable zen browser from flake";
  config = mkIf cfg.default-user.enable {
    home-manager = {
      users.leonardo = {
        imports = [
          inputs.zen-browser.homeModules.default
        ];
        programs.zen-browser = {
          enable = true;
          policies = {
            AutofillAddressEnabled = true;
            AutofillCreditCardEnabled = false;
            DisableAppUpdate = true;
            DisableFeedbackCommands = true;
            DisableFirefoxStudies = true;
            DisablePocket = true; # save webs for later reading
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
          };
        };
      };
    };
  };
}
