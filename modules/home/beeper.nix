{ pkgs, ... }:

let
  pname = "beeper";
  version = "4.1.1";
  src = pkgs.fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-${version}.AppImage";
    hash = "sha256-uTPprGSOi2LlxzrHRtL2KSMPR4bOmQbV8g0Fm19T0n0=";
  };
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;

    postExtract = ''
      # disable creating a desktop file and icon in the home folder during runtime
      linuxConfigFilename=$out/resources/app/build/main/linux-*.mjs
      echo "export function registerLinuxConfig() {}" > $linuxConfigFilename

      # disable auto update
      sed -i 's/[^=]*\.auto_update_disabled/true/' $out/resources/app/build/main/main-entry-*.mjs

      # prevent updates
      sed -i -E 's/executeDownload\([^)]+\)\{/executeDownload(){return;/g' $out/resources/app/build/main/main-entry-*.mjs

      # hide version status element on about page otherwise a error message is shown
      sed -i '$ a\.subview-prefs-about > div:nth-child(2) {display: none;}' $out/resources/app/build/renderer/PrefsPanes-*.css
    '';
  };
in
  pkgs.beeper.overrideAttrs {
    inherit version;
    src = appimageContents;
  }
