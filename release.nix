{ ... }:
let
  pkgs' = (import <nixpkgs> {
    config.contentAddressedByDefault = true;
  });
  mobileReleaseTools = (import <mobile/lib/release-tools.nix> {
    pkgs = pkgs';
  });
  #inherit (mobileReleaseTools.withPkgs pkgs') evalWithConfiguration;

  pp-config = (mobileReleaseTools.evalWith {
    modules = [ ./pinephone-configuration-cross-official.nix ];
    device = "pine64-pinephone";
  });

  pp-config2 = import <mobile/lib/eval-with-configuration.nix> ({
    pkgs = pkgs';
    configuration = [ ./pinephone-configuration-cross-official.nix ];
    device = "pine64-pinephone";
  });

in {
  bareConfig = pp-config;
  image = pp-config.config.mobile.outputs.default;
  image2 = pp-config2.config.mobile.outputs.default;
}

