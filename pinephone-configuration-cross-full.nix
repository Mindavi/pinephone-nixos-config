{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration-cross.nix
  ];

  nix = {
    settings = {
      sandbox = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  mobile.generatedFilesystems.rootfs = lib.mkDefault {
    # explicitly different to prevent from booting from sd card into eMMC installed OS
    label = lib.mkForce "nixos-cross-full";
    # I don't think there's any need to change the id.
  };

  nixpkgs = {
    #config.contentAddressedByDefault = true;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      #"arm-trusted-firmware-sun50i_a64"
      "pinephone-qfirehose"
      "pine64-pinephone-firmware"
    ];
  };

  # required for cross-compilation
  security.polkit.enable = lib.mkForce true;

  #documentation.enable = lib.mkOverride 5 true;  # breaks mobile-nixos impots
  networking.wireless.enable = false;
  #networking.networkmanager.enable = true;

  environment.systemPackages = [
    pkgs.bc
    pkgs.cowsay
    #pkgs.feh
    pkgs.file
    pkgs.fzf
    pkgs.git
    pkgs.htop
    pkgs.jq
    #pkgs.onboard
    pkgs.openssh
    pkgs.progress
    pkgs.rsync
    pkgs.screen
    pkgs.sl
    #pkgs.squeekboard
    pkgs.st
    pkgs.usbutils
    pkgs.unzip
    pkgs.wget
    pkgs.whois
    pkgs.tree
    pkgs.vim

    pkgs.pine64-pinephone.qfirehose
  ];

  environment.etc."machine-info".text = ''
    CHASSIS="handset"
  '';


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
  #    wl-clipboard
  #    mako
  #    alacritty
      dmenu
      wofi
    ];
  };

  #programs.xwayland.enable = false;

  #hardware.sensor.iio.enable = true;
  hardware.firmware = [ config.mobile.device.firmware ];

  networking.useDHCP = false;

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

  # disable to exclude mesa from the closure
  hardware.opengl.enable = true;

  time.timeZone = "Europe/Amsterdam";

  users.users.rick = {
    isNormalUser = true;
    initialPassword = "1234";
    extraGroups = [ "wheel" "networkmanager" "input" "video" "feedbackd" "dialout" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus" ];
  };

  system.stateVersion = "22.05";
}

