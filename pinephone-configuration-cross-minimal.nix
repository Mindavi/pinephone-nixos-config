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
    label = lib.mkForce "nixos-cross-minimal";
    # I don't think there's any need to change the id.
  };

  nixpkgs = {
    #config.contentAddressedByDefault = true;
    config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      #"arm-trusted-firmware-sun50i_a64"
      "pine64-pinephone-firmware"
    ];
  };
  documentation.nixos.enable = false;

  #documentation.enable = lib.mkOverride 5 true;  # breaks mobile-nixos imports
  networking.wireless.enable = false;
  #networking.networkmanager.enable = true;

  environment.systemPackages = [
    pkgs.bc
    pkgs.cowsay
    pkgs.file
    pkgs.fzf
    pkgs.git
    pkgs.htop
    pkgs.jq
    pkgs.openssh
    pkgs.progress
    pkgs.rsync
    pkgs.screen
    pkgs.sl
    pkgs.st
    pkgs.usbutils
    pkgs.unzip
    pkgs.wget
    pkgs.whois
    pkgs.tree
    pkgs.vim
  ];

  environment.etc."machine-info".text = ''
    CHASSIS="handset"
  '';

  hardware.firmware = [ config.mobile.device.firmware ];

  networking.useDHCP = false;

  # ntp crashes on boot (maybe only when the time is 00:00 in 1980?)
  services.ntp.enable = true;
  users.users.ntp.group = "ntp";
  users.groups.ntp = {};
  networking.hostName = "pinephone-nixos-cross-minimal";

  services.openssh.enable = true;

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

  time.timeZone = "Europe/Amsterdam";

  users.users.rick = {
    isNormalUser = true;
    initialPassword = "1234";
    extraGroups = [ "wheel" "networkmanager" "input" "video" "feedbackd" "dialout" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus" ];
  };

  system.stateVersion = "22.05";
}

