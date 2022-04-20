{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration-cross.nix
  ];

  nix = {
    package = pkgs.nixUnstable;
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  mobile.generatedFilesystems.rootfs = lib.mkDefault {
    label = lib.mkForce "nixos-cross"; # explicitly different to prevent from booting from sd card into eMMC installed OS
    # I don't think there's any need to change the id.
  };

  nixpkgs = {
    #config.contentAddressedByDefault = true;
  };

  # required for cross-compilation
  security.polkit.enable = lib.mkForce true;
  #services.udisks2.enable = lib.mkForce true;
  # May break proper audio from pulseaudio -- to check (required when cross-compiling polkit fails)
  #security.rtkit.enable = lib.mkForce false;

  #documentation.enable = lib.mkOverride 5 true;
  networking.wireless.enable = false;
  #networking.networkmanager.enable = true;

  # Needs a fix in the checkPhase to cross-compile properly.
  # logrotate.conf> /build/.attr-0l2nkwhif96f51f4amnlf414lhl4rv9vh8iffyp431v6s28gsr90: line 14: /nix/store/yvknva89jx34vw6ix9f03ny4nrymhvfc-coreutils-aarch64-unknown-linux-gnu-9.0/bin/id: cannot execute binary file: Exec format error
  # error: builder for '/nix/store/3c3s3afzxj31csa07506fy74sapk3bif-logrotate.conf.drv' failed with exit code 126;
  services.logrotate.checkConfig = false;

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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "pinephone-qfirehose"
    "pine64-pinephone-firmware"
  ];

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

  # global useDHCP flag is deprecated, let's set it to false
  networking.useDHCP = false;

  # ntp crashes on boot (maybe only when the time is 00:00 in 1980?)
  services.ntp.enable = true;
  users.users.ntp.group = "ntp";
  users.groups.ntp = {};
  networking.hostName = "pinephone-nixos";

  services.dbus.packages = [ pkgs.callaudiod ];  # cross-compilation broken

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

  system.stateVersion = "21.05";
}

