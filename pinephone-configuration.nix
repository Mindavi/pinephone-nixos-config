{ config, pkgs, mobile-nixos, lib, ... }:

{
  imports = [
    (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixVersions.unstable;
    settings.sandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  documentation.enable = lib.mkOverride 5 true;
  #programs.phosh = {
  #  enable = true;
  #  phocConfig.xwayland = "false";
  #};

  networking.wireless.enable = false;
  networking.networkmanager.enable = true;

  environment.systemPackages = [
    pkgs.bc
    pkgs.brightnessctl
    #pkgs.calls
    #pkgs.chatty
    pkgs.cowsay
    #pkgs.exa
    pkgs.feh
    pkgs.file
    pkgs.fzf
    pkgs.git
    pkgs.gnome.gnome-chess
    #pkgs.gnome.gnome-podcasts
    pkgs.htop
    pkgs.jq
    pkgs.kgx
    #pkgs.nomacs
    pkgs.megapixels
    pkgs.onboard
    pkgs.openssh
    pkgs.portfolio-filemanager
    pkgs.progress
    pkgs.ripgrep
    pkgs.rsync
    #pkgs.sgtpuzzles
    pkgs.screen
    pkgs.sl
    pkgs.squeekboard
    pkgs.st
    pkgs.usbutils
    pkgs.unzip
    pkgs.wget
    pkgs.whois
    pkgs.tree
    pkgs.vim

    pkgs.pine64-pinephone.qfirehose
  ] ++ (with pkgs.plasma5Packages; [
    alligator
    #angelfish
    #audiotube # build broken, cannot find <span> include
    calindori
    kalk
    kasts
    kclock
    keysmith
    koko
    krecorder
    ktrip
    # kweather build is broken
    #kweather
    plasma-dialer
    plasma-phonebook
    plasma-settings
    # qcoro marked broken for aarch64
    # spacebar
  ]);

  environment.etc."machine-info".text = ''
    CHASSIS="handset"
  '';

  # Fix issues with pkgconfig in mobile-nixos (maybe there are others too?)
  # then set allowAliases to `false`.
  nixpkgs.config.allowAliases = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "arm-trusted-firmware-sun50i_a64"
    "pinephone-qfirehose"
    "pine64-pinephone-firmware"
  ];

  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  extraPackages = with pkgs; [
  #    swaylock
  #    swayidle
  #    wl-clipboard
  #    mako
  #    alacritty
  #    wofi
  #  ];
  #};

  programs.calls.enable = true;

  #programs.xwayland.enable = false;

  hardware.sensor.iio.enable = true;
  hardware.firmware = [ config.mobile.device.firmware ];

  # global useDHCP flag is deprecated, let's set it to false
  networking.useDHCP = false;

  services.xserver = {
    enable = true;
    desktopManager = {
      #phosh = {
      #  enable = true;
      #  user = "rick";
      #  group = "users";
      #};
      plasma5.mobile = {
        enable = true;
        # kweather build broken, spacebar build broken
        installRecommendedSoftware = false;
      };
    };
    displayManager = {
      defaultSession = "plasma-mobile";
      sddm.enable = true;
    };
    videoDrivers = lib.mkDefault [ "modesetting" "fbdev" ];
  };

  # ntp crashes on boot (maybe only when the time is 00:00 in 1980?)
  services.ntp.enable = true;
  users.users.ntp.group = "ntp";
  users.groups.ntp = {};
  networking.hostName = "pinephone-nixos";

  services.dbus.packages = [ pkgs.callaudiod ];
  
  services.openssh.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.sit0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [
    # vnc
    5900
  ];
  networking.firewall.allowedTCPPorts = [
    # vnc
    5900
  ];

  powerManagement.enable = true;
  services.upower.enable = true;

  hardware.opengl.enable = true;

  time.timeZone = "Europe/Amsterdam";
  
  users.users.rick = {
    isNormalUser = true;
    initialPassword = "1234";
    extraGroups = [ "wheel" "networkmanager" "input" "video" "feedbackd" "dialout" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus" ];
  };

  system.stateVersion = "21.11";
}

