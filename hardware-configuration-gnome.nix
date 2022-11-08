# NOTE: this file was generated by the Mobile NixOS installer.
{ config, lib, pkgs, ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c81b2076-ad53-4e92-a012-7c353434ddc4";
      fsType = "ext4";
    };
  };
  
  boot.initrd.luks.devices = {
    "LUKS-PP-RICK-ROOTFS" = {
      device = "/dev/disk/by-uuid/effd829d-a82a-423d-b9c5-146ef5f6e26e";
    };
  };

  nix.settings.max-jobs = lib.mkDefault 2;
}
