{ pkgs, lib, config, ... }: {
  imports = [
    ../modules/emacs
    ../modules/home
  ];
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  services.openssh = {
    enable = true;
  };

  santi-modules = {
    emacs.enable = true;
    nushell.enable = true;
    git.enable = true;
    programs.enable = false;
    home.enable = true;
  };

  nix.enable = false;
  nix.channel.enable = false;
  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    warn-dirty = false;
    lazy-trees = true;
    http-connections = 50;
  };

  users.users.leonardo = {
    name = "leo";
    home = lib.mkForce "/Users/leo";
    createHome = true;
  };

  environment.systemPackages = with pkgs; [
    slack
    nh
    betterdisplay
    alt-tab-macos
    raycast
    whatsapp-for-mac
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  networking.hostName = "nami";

  system.defaults.smb = {
    NetBIOSName       = config.networking.hostName;
    ServerDescription = config.networking.hostName;
  };

  system.defaults = {
    controlcenter.BatteryShowPercentage = true;
  };

  system.defaults.LaunchServices = {
    LSQuarantine = false;
  };

  system.defaults.CustomSystemPreferences."com.apple.AdLib" = {
    allowApplePersonalizedAdvertising = false;
    allowIdentifierForAdvertising     = false;
    forceLimitAdTracking              = true;
    personalizedAdsMigrated           = false;
  };

  system.defaults.CustomSystemPreferences."com.apple.screensaver" = {
    # Request password immediately.
    askForPassword      = 1;
    askForPasswordDelay = 0;
  };

  system.defaults.NSGlobalDomain = {
    AppleShowAllFiles = true;
    AppleShowAllExtensions = true;


    AppleICUForce24HourTime = true;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSWindowShouldDragOnGesture = true;

    NSScrollAnimationEnabled = true;
    NSWindowResizeTime       = 0.003;
    AppleWindowTabbingMode = "always"; # Always prefer tabs for new windows
    ApplePressAndHoldEnabled = false;  # No ligatures when you press and hold a key, just repeat it.

    
    InitialKeyRepeat = 12;
    KeyRepeat        = 5;

    AppleSpacesSwitchOnActivate = false;

    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits      = 1;
    AppleTemperatureUnit  = "Celsius";
      
    "com.apple.springing.enabled" = true;
    "com.apple.springing.delay"   = 0.0;
  };

  system.defaults.CustomSystemPreferences."com.apple.Accessibility".ReduceMotionEnabled = 1;

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles      = true;

    FXEnableExtensionChangeWarning = true;
    FXPreferredViewStyle           = "Nlsv"; # List style.
    FXRemoveOldTrashItems          = true;

    _FXShowPosixPathInTitle      = true;
    _FXSortFoldersFirst          = true;
    _FXSortFoldersFirstOnDesktop = false;

    NewWindowTarget = "Home";

    QuitMenuItem = true; # Allow quitting of Finder application

    ShowExternalHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop     = true;
    ShowPathbar                     = true;
    ShowRemovableMediaOnDesktop     = true;
    ShowStatusBar                   = true;
  };

  system.primaryUser = "leonardo";
  
  system.stateVersion = 6;
}
