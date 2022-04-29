{ config, pkgs, mobile-nixos, lib, ... }:

{
  imports = [
    (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
    ./hardware-configuration.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    useSandbox = true;
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

  # Needs a fix in the checkPhase to cross-compile properly.
  # logrotate.conf> /build/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 14: /nix/store/yvknva89jx34vw6ix9f03ny4nrymhvfc-coreutils-aarch64-unknown-linux-gnu-9.0/bin/id: cannot execute binary file: Exec format error
  # error: builder for '/nix/store/3c3s3afzxj31csa07506fy74sapk3bif-logrotate.conf.drv' failed with exit code 126;
  services.logrotate.checkConfig = false;

  environment.systemPackages = [
    pkgs.bc
    pkgs.brightnessctl
    pkgs.calls
    pkgs.chatty
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
    angelfish
    audiotube
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
    spacebar
  ]);

  environment.etc."machine-info".text = ''
    CHASSIS="handset"
  '';

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

  #programs.xwayland.enable = false;

  hardware.sensor.iio.enable = true;
  hardware.firmware = [ config.mobile.device.firmware ];

  # global useDHCP flag is deprecated, let's set it to false
  networking.useDHCP = false;

  services.xserver = {
    enable = true;
    libinput.enable = true;

    displayManager.sddm.enable = true;
    #desktopManager.plasma5.enable = true;
    desktopManager.plasma5.mobile.enable = true;
    # kweather build broken, preventing update
    desktopManager.plasma5.mobile.installRecommendedSoftware = false;
    displayManager.defaultSession = "plasma-mobile";
    videoDrivers = lib.mkDefault [ "modesetting" "fbdev" ];

    #displayManager.gdm.enable = true;
    #displayManager.gdm.wayland = true;
    #desktopManager.gnome.enable = true;
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

  services.sshd.enable = true;

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

