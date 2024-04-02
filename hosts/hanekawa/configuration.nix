# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hanekawa"; # Define your hostname.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  # Enable the X11 windowing system.
  services.touchegg.enable = true;
  services.xserver = {
    enable = true;
    xkb.layout = "br";
    xkb.variant = "";
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        scrollMethod = "twofinger";
        clickMethod = "clickfinger";
        tappingButtonMap = "lrm";
      };
    };
    videoDrivers = [ "nvidia" ];
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.thermald.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  
  security.rtkit.enable = true;
  services.fstrim.enable = lib.mkDefault true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leonardo = {
    isNormalUser = true;
    description = "leonardo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  fonts = {
    fontconfig.enable = true;
    packages = [(pkgs.nerdfonts.override { fonts = [ "Iosevka" "FiraCode" ]; })];
  };

  # Allow unfree packages
  services.openssh.enable = true;
  programs.ssh = {
    forwardX11 = true;
    startAgent = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
