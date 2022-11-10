{ config, lib, pkgs, mobile-nixos, ... }:

{
  imports = [
    (import "${mobile-nixos}/lib/configuration.nix" { device = "pine64-pinephone"; })
    ./hardware-configuration-gnome.nix
    "${mobile-nixos}/examples/phosh/phosh.nix"
  ];

  networking.hostName = "pp-rick";

  environment.systemPackages = with pkgs; [
    bat
    ripgrep
    fzf
    pv

    wget
    vim
    gitFull
    htop
    keepassxc
    tree
    jq
    screen
    file
    p7zip

    element-desktop
    tdesktop

    brightnessctl
    cowsay

    calls
    chatty
    gnome.gnome-chess
    portfolio-filemanager
    #sgtpuzzles-mobile  # adds load of apps to launcher
    squeekboard
    st

    feh
    gnome.eog
    vlc

    firefox
    gnome.geary
    dino
    #fractal
    nheko

    #freetube  # unsupported
    youtube-dl
    pipe-viewer
    gtk-pipe-viewer
    minitube

    lollypop
    amberol
    spot

    gnome-podcasts

    gnome.gnome-sound-recorder

    shortwave

    lingot

    CuboCore.coreimage

    gnome.gnome-calendar
    calcurse

    gnome.gnome-contacts
    goobook

    gnome-usage

    CuboCore.corestats

    evince
    CuboCore.corepdf

    numberstation

    gnome.gnome-calculator

    pure-maps
    gnome.gnome-maps
    mepo

    libsForQt5.pix
    libsForQt5.calindori
    libsForQt5.koko
    libsForQt5.ark
    libsForQt5.nota
    libsForQt5.kweather
    libsForQt5.kasts
    #libsForQt5.plasma-phonebook
    libsForQt5.kclock
    libsForQt5.angelfish
    libsForQt5.keysmith
    libsForQt5.krecorder
    # interferes with other sms apps (receives sms duplicated)
    #libsForQt5.spacebar
  ];

  environment.variables = {
    # https://github.com/qt/qtbase/blob/ab28ff2207e8f33754c79793089dbf943d67736d/src/gui/kernel/qguiapplication.cpp#L1417-L1420
    QT_QPA_PLATFORM = "wayland";
    # https://invent.kde.org/plasma-mobile/angelfish/-/blob/049c78995fe6d7e0994f73f7b95fd33c65b41343/lib/settingshelper.cpp#L15
    QT_QUICK_CONTROLS_MOBILE = "true";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services.openssh.enable = true;
  # Ensure gnome maps can access location via geoclue.
  # Should probaly go into nixos/modules/services/x11/desktop-managers/phosh.nix.
  services.geoclue2.appConfig."sm.puri.Phosh".isAllowed = true;

  nix = {
    settings = {
      sandbox = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
      builders-use-substitutes = true
      timeout = 86400  # 24 hours
    '';
  };

  # e.g. platformio and element use this, so make sure this is enabled.
  security.unprivilegedUsernsClone = true;

  nixpkgs.config = {
    # Even though it's not recommended, I'm going to enable this anyway.
    # I like it to be a hard error when an attribute is renamed or whatever.
    # Can always disable this again when it causes issues.
    allowAliases = false;
    #contentAddressedByDefault = true;
  };

  programs.bash.enableCompletion = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      8080
      5000
    ];
  };

  #
  # Opinionated defaults
  #
  
  # Use Network Manager
  networking.wireless.enable = false;
  networking.networkmanager.enable = true;
  
  # Use PulseAudio
  hardware.pulseaudio.enable = true;
  
  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  
  # Bluetooth audio
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  
  # Enable power management options
  powerManagement.enable = true;
  
  # It's recommended to keep enabled on these constrained devices
  zramSwap.enable = true;

  # Auto-login for phosh
  services.xserver.desktopManager.phosh = {
    user = "rick";
  };

  #
  # User configuration
  #
  
  users.users."rick" = {
    isNormalUser = true;
    description = "rick";
    hashedPassword = "$6$rOpjbuF0U68X.j8p$Xt5TSQjfp2tzcmxa2LX5GeTTn8NdL87DiCbsqxNz/ApZx5k.RgDE7Mv4Niqf3l3Nz2QeSoEutRlHohPcexPmu.";
    extraGroups = [
      "dialout"
      "feedbackd"
      "networkmanager"
      "video"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHX8vXQQS3giFtiYf8rYkIAhKpQlc/2wNLj1EOvyfl9D4 rick@nixos-asus" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
